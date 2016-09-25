require_relative './examples_helper'
require 'busy-administrator'

def main
  run_example "nested_dictionaries" do
    target = {
      apples: {
        bananas: {
          carrots: 1,
          durians: 2,
          eggplants: 3
        }
      },
      figs: {
        grapes: {
          huckleberries: 4,
          ita_palms: 5
        },
        jujubes: 6,
        kiwis: 7,
        lemons: 8
      }
    }

    BusyAdministrator::Display.debug(target)
  end

  run_example "arrays and dictionaries" do
    target = {
      apples: {
        bananas: [
          'carrots',
          'durians'
        ],
        eggplants: 1
      },
      figs: {
        grapes: [
          'huckleberries',
          'ita_palms'
        ],
        jujubes: [
          6, 
          7, 
          8
        ],
        kiwis: [
          'lemons',
          9,
          10
        ]
      }
    }

    BusyAdministrator::Display.debug(target)
  end
end

main