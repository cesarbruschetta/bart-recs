# Outputs a random number 
#
# Usage:
#   {{ int | random_number }}
#   ex: {{ 100 | random_number }}

module RandomNumberSelector
    def random_number( input )
        index = rand(0...input)
        "#{index}"
    end
end

Liquid::Template.register_filter(RandomNumberSelector)