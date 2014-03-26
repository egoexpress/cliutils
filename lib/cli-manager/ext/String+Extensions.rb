#  ======================================================
#  String Class
#  ======================================================
class String
  #  ====================================================
  #  Color String Methods
  #  ====================================================
  #  ----------------------------------------------------
  #  colorize method
  #
  #  Outputs a string in a formatted color.
  #  @param color_code The code to use
  #  @return Void
  #  ----------------------------------------------------
  def colorize(color_code)
    "\e[#{ color_code }m#{ self }\e[0m"
  end
  
  def blue; colorize(34) end
  def cyan; colorize(36) end
  def green; colorize(32) end
  def purple; colorize(35) end
  def red; colorize(31) end
  def yellow; colorize(33) end
end
