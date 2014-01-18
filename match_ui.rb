require './match'

class MatchUI
  BoardFontSize = 30
  PlayerFontSize = 24
  PanelFontSize = 24
  NumPadX = 8
  NumPadY = ((G::BoardTile - BoardFontSize) / 2).to_i
  PlayerNumPadX = 10
  PlayerNumPadY = ((G::BoardTile - PlayerFontSize) / 2).to_i

  attr_reader :over

  def initialize
    @match = Match.new
    @over = false
    @selected_x = -1
    @selected_y = -1
    @waiting_number = false

    @board_font = Gosu::Font.new G.window, 'data/font/DroidSansBold.ttf', BoardFontSize
    @player_font = Gosu::Font.new G.window, 'data/font/DroidSansMono.ttf', PlayerFontSize
    @panel_font = Gosu::Font.new G.window, 'data/font/DroidSansMono.ttf', PanelFontSize
  end

  def update
    @over = true if Controller.key_pressed?(Gosu::KbSpace)

    if Controller.key_pressed?(Gosu::MsLeft) and
      mouse_on_board? and
      not @match.fixed_cell? mouse_board_y, mouse_board_x
      @selected_x = mouse_board_x
      @selected_y = mouse_board_y
      @waiting_number = true
    end

    if @waiting_number
      number = -1
      number = 1 if Controller.key_pressed?(Gosu::Kb1)
      number = 2 if Controller.key_pressed?(Gosu::Kb2)
      number = 3 if Controller.key_pressed?(Gosu::Kb3)
      number = 4 if Controller.key_pressed?(Gosu::Kb4)
      number = 5 if Controller.key_pressed?(Gosu::Kb5)
      number = 6 if Controller.key_pressed?(Gosu::Kb6)
      number = 7 if Controller.key_pressed?(Gosu::Kb7)
      number = 8 if Controller.key_pressed?(Gosu::Kb8)
      number = 9 if Controller.key_pressed?(Gosu::Kb9)
      
      if number > -1
        @waiting_number = false
        
        @match.set_number @selected_y, @selected_x, number
        @selected_x = -1
        @selected_y = -1
      end

      if Controller.key_pressed?(Gosu::KbDelete)
        @match.erase @selected_y, @selected_x

        @waiting_number = false
        @selected_x = -1
        @selected_y = -1
      end
    end
  end

  def draw
    draw_background
    draw_board
    draw_panel
    draw_cursor
  end

private

  def draw_background
    c1 = Gosu::Color.new(0xFFFFFFFF)
    c2 = Gosu::Color.new(0xFFFFFFFF)

    G.window.draw_quad(
      0, 0, c1,
      G::ScreenWidth, 0, c1,
      0, G::ScreenHeight, c2,
      G::ScreenWidth, G::ScreenHeight, c2,
    0)
  end
  
  def draw_cursor
    c = Gosu::Color.new(0xFF00FF00)
    x = G.window.mouse_x
    x2 = x + 5
    y = G.window.mouse_y
    y2 = y + 5

    G.window.draw_quad(
      x, y, c,
      x2, y, c,
      x, y2, c,
      x2, y2, c,
      0)
  end

  def draw_board
    draw_cell_backgrounds
    draw_grid
    draw_numbers
  end

  def draw_panel
    if @match.win
      text = "#{@match.ellapsed.to_i} seconds"
      x = 10
      y = 10
      color = Gosu::Color.new(0xFF222222)
      
      @panel_font.draw text, x, y, 0, 1, 1, color
    end
  end

  def draw_cell_backgrounds
    if mouse_on_board?
      x = mouse_board_x
      y = mouse_board_y
      color = Gosu::Color.new(0xFF338888)

      paint_cell x, y, color
    end

    if @waiting_number
      x = @selected_x
      y = @selected_y
      color = Gosu::Color.new(0xFFFF3333)

      paint_cell x, y, color
    end

    bg_color = Gosu::Color.new(0xFFFFFFFF)
    win_color = Gosu::Color.new(0xFF99FF99)

    Size.times do |i|
      Size.times do |j|
        paint_cell j, i, bg_color if @match.fixed_cell? i, j 
        paint_cell j, i, win_color if @match.win
      end
    end
  end

  def draw_grid
    color = Gosu::Color.new(0xFF000000)
    
    (Size + 1).times do |i|
      stroke = (i % Sqrt == 0) ? 3 : 1
      size = Size * G::BoardTile

      xv = G::BoardX + i * G::BoardTile
      yv = G::BoardY
      G.window.draw_vertical_line xv, yv, size, stroke, color

      yh = G::BoardY + i * G::BoardTile
      xh = G::BoardX
      G.window.draw_horizontal_line xh, yh, size, stroke, color
    end
  end

  def draw_numbers
    color = Gosu::Color.new(0xFF000000)
    color2 = Gosu::Color.new(0xFF222222)

    @match.board.lines.each_with_index do |line, i|
      line.each_with_index do |cell, j|
        next unless (1..Size).include? cell


        if @match.fixed_cell? i, j
          x = G::BoardX + j * G::BoardTile + NumPadX
          y = G::BoardY + i * G::BoardTile + NumPadY
          @board_font.draw cell, x, y, 0, 1, 1, color
        else
          x = G::BoardX + j * G::BoardTile + PlayerNumPadX
          y = G::BoardY + i * G::BoardTile + PlayerNumPadY
          @player_font.draw cell, x, y, 0, 1, 1, color2
        end
      end
    end
  end

  def paint_cell x, y, color
    x = G::BoardX + x * G::BoardTile
    x2 = x + G::BoardTile
    y = G::BoardY + y * G::BoardTile
    y2 = y + G::BoardTile

    G.window.draw_quad(
      x, y, color,
      x2, y, color,
      x, y2, color,
      x2, y2, color,
      0)
  end

  def mouse_board_x
    (G.window.mouse_x - G::BoardX).to_i / G::BoardTile
  end
  
  def mouse_board_y
    (G.window.mouse_y - G::BoardY).to_i / G::BoardTile
  end

  def mouse_on_board?
    (0..(Size - 1)).include? mouse_board_x and
    (0..(Size - 1)).include? mouse_board_y
  end
end
