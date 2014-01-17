require 'gosu'
require './g'
require './match_ui'
require './controller'

class Game < Gosu::Window
  def initialize
    super G::ScreenWidth, G::ScreenHeight, false
    self.caption = 'Yuri DS Sudoku'
    G.window = self

    Controller.initialize
    @match_ui = MatchUI.new
  end

  def update
    Controller.update
    @match_ui.update

    @match_ui = MatchUI.new if @match_ui.over
  end
   
  def draw
    @match_ui.draw
  end

  def draw_horizontal_line x, y, size, stroke, color
    stroke.times do |i|
      draw_line x, y + i, color, x + size, y + i, color, 0
    end
  end

  def draw_vertical_line x, y, size, stroke, color
    stroke.times do |i|
      draw_line x + i, y, color, x + i, y + size, color, 0
    end
  end
end

Game.new.show
