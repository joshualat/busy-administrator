module BusyAdministrator
  class MemoryMiddleware
    module Analyzer
      def analyze(key:, value:)
        if analyzer = request.env['busy-administrator-analyzer']
          analyzer.include(key: key, value: value)
        end
      end
    end

    def initialize(app)
      @app = app
    end

    def assets_request?(env)
      env['PATH_INFO'].ends_with?('.js') || env['PATH_INFO'].ends_with?('.css')
    end

    def enabled?
      ENV['BUSY_ADMINISTRATOR_PROFILE'] == "YES"
    end

    def disabled?
      not enabled?
    end

    def gc_enabled?
      ENV['BUSY_ADMINISTRATOR_GC_ENABLED'] == "YES"
    end

    def call(env)
      response = nil

      if assets_request?(env) || disabled?
        response = @app.call(env)
      else
        results = BusyAdministrator::MemoryUtils.profile(gc_enabled: gc_enabled?) do |analyzer|
          env['busy-administrator-analyzer'] = analyzer

          response = @app.call(env)
        end

        BusyAdministrator::Display.debug(results)
      end

      response
    end
  end
end