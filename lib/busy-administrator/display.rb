module BusyAdministrator
  module Display
    def self.debug(target, indent: 0)
      if target.is_a?(Hash)
        indent_space = " " * (indent * 4)
        puts indent_space + "{"

        indent += 1

        target.each do |key, value|
          if value.is_a?(Hash) || value.is_a?(Array)
            indent_space = " " * (indent * 4)
            puts indent_space + "#{ key }:"

            self.debug(value, indent: indent + 1)
          else
            indent_space = " " * (indent * 4)
            puts indent_space + "#{ key }: #{ value }"
          end
        end

        indent -= 1
        indent_space = " " * (indent * 4)
        puts indent_space + "}"
      elsif target.is_a?(Array)
        indent_space = " " * (indent * 4)
        puts indent_space + "["

        target.each do |element|
          self.debug(element, indent: indent + 1)
        end

        indent_space = " " * (indent * 4)
        puts indent_space + "]"
      else
        indent_space = " " * (indent * 4)
        puts indent_space + "#{ target }"
      end
    end
  end
end