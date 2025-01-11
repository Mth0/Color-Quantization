using StatsBase: countmap

function dist_img(img, original_img)
    return norm(original_img .- img)
end

function count_colors(img)
    #transform the matrix into a vector of pixels
    vectorized_img = reshape(img, size(img, 1), :)
    #filter the colors
    colors = map(color -> tuple(color...), eachcol(vectorized_img))
    #count them
    colors_count = countmap(colors)
    return colors_count
end

function construct_pizza(colors_count)
    #get the total of pixels
    total = sum(values(colors_count))
    #define the frequency of each color
    freqs = [(key, value / total) for (key, value) in colors_count]
    #separate the colors
    keys = [[key[1] key[2] key[3]] for (key, _) in freqs]
    #compute the probability of each color
    probs = cumsum([value for (_, value) in freqs])
    return keys, probs
end

function select_from_pizza(pizza)
    r = rand()
    for (i, p) in enumerate(pizza)
        if r <= p
            return i
        end
    end
    return length(pizza)
end

function create_palette(possible_colors, pizza, palette_size=16)
    palette = Set()
    while length(palette) < palette_size
        push!(palette, possible_colors[select_from_pizza(pizza)])
    end
    return collect(palette)
end