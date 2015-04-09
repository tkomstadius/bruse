class Array
  # Finds the first non-empty array in an array
  def find_first_array
    self.each do |d|
      return d if !d.empty?
    end
    return []
  end
end
