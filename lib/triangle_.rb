def get_array_length(row)
  return row + 1
end

# generate the array by the character of Pascal Triangle
# Point value = Side Value 1 + Side Value 2
def generate_array(row)
  above_array = []
  generated_array = []
  (0 ... (row + 1)).each{| l |
    if l == 0
      above_array = [1]
      generated_array = [1]
    else
      (0 ... get_array_length(l)).each {| index |
        above_first_index = index - 1
        above_second_index = index
        # if the index of above array not exists
        if above_first_index < 0
          above_first_value = 0
        else
          above_first_value = above_array[above_first_index]
        end
        # if the index exceed the lengtgh of above array
        if above_second_index >= above_array.length
          above_second_value = 0
        else
          above_second_value = above_array[above_second_index]
        end
        generated_array[index] = above_first_value + above_second_value
        # at the last calculated number set the generated_array to above_array in order to next loop
        if index + 1 == get_array_length(l)
          above_array = generated_array.clone
        end
      }
    end
  }

  # retuern generated_array
  generated_array
end

if ARGV.size == 1
  row = ARGV[0].to_i
  p generate_array(row)
else
  p 'usage: ruby triangle.rb [row]'
end

