class Controller
  def self.initialize
    @@keys = [
      Gosu::Kb1, Gosu::Kb2, Gosu::Kb3, Gosu::Kb4, Gosu::Kb5,
      Gosu::Kb6, Gosu::Kb7, Gosu::Kb8, Gosu::Kb9, 
      Gosu::KbUp, Gosu::KbRight, Gosu::KbDown, Gosu::KbLeft,
      Gosu::KbSpace, Gosu::KbReturn, Gosu::KbBackspace, Gosu::KbEscape, Gosu::KbDelete,
      Gosu::MsLeft, Gosu::MsRight
    ]
    @@down = []
    @@prev_down = []
  end

  def self.update
    @@prev_down = @@down.clone
    @@down.clear

    @@keys.each do |k|
      if G.window.button_down? k
        @@down << k
      end
    end
  end

  def self.key_pressed? key
    @@prev_down.index(key).nil? and @@down.index(key)
  end

  def self.key_down? key
    @@down.index(key)
  end

  def self.key_released? key
    @@prev_down.index(key) and @@down.index(key).nil?
  end
end
