module Graphics

  A = { 0 => '  _____' }
  B = { 0 => '  |  \|' }
  C = { 0 => '      |', 1 => '  O   |' }
  D = { 0 => '      |', 2 => '  |   |', 3 => ' `|   |', 4 => ' `|´  |' }
  E = { 0 => '      |', 5 => ' /    |', 6 => ' / \  |' }
  F = { 0 => '______|' }

  GRAPHICS = [A, B, C, D, E, F]

  def show_gallow(counter)
    GRAPHICS.each do |hash| 
      puts hash[hash.keys.select { |key| counter >= key }.max]
    end
    puts
  end

end