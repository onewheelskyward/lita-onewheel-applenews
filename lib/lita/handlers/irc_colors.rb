module IrcColors
  prefix = "\x03"
  @white  = "#{prefix}00"
  @black  = "#{prefix}01"
  @blue   = "#{prefix}02"
  @green  = "#{prefix}03"
  @red    = "#{prefix}04"
  @brown  = "#{prefix}05"
  @purple = "#{prefix}06"
  @orange = "#{prefix}07"
  @yellow = "#{prefix}08"
  @lime   = "#{prefix}09"
  @teal   = "#{prefix}10"
  @aqua   = "#{prefix}11"
  @royal  = "#{prefix}12"
  @pink   = "#{prefix}13"
  @grey   = "#{prefix}14"
  @silver = "#{prefix}15"
  @reset  = prefix

  class << self
    attr_reader :white,
                :black,
                :blue,
                :green,
                :red,
                :brown,
                :purple,
                :orange,
                :yellow,
                :lime,
                :teal,
                :aqua,
                :royal,
                :pink,
                :grey,
                :silver,
                :reset
  end

  def initialize
  end
end
