function color_img(img_matrix, palette, new_img=0, index_img=0)
    #recolor each pixel with the nearest color
    if new_img == 0
        new_img = zeros(size(img_matrix))
    end
    if index_img == 0
        index_img = ones(Int64, size(img_matrix, 2), size(img_matrix, 3))
    end
    
    for i in 1:size(img_matrix)[2]
        for j in 1:size(img_matrix)[3]
            #get the color with minimum distance
            idx = argmin([norm(img_matrix[:, i, j] - color) for color in palette])
            new_img[:, i, j] = palette[idx]
            index_img[i, j] = idx
        end
    end
    return new_img, index_img
end

function change_palette(f, possible_colors, pizza, f_val,
                        img_matrix, palette_img,
                        index_img, palette,
                        number_changes_local_search, best_img=0,
                        number_neighbours=10)

    #define some important variables
    palette_range = 1:size(palette, 1)

    if best_img == 0
        best_img = copy(palette_img)
    end

    #try different palettes
    for n in 1:number_neighbours
        #create a new palette
        new_palette = copy(palette)

        #index that will change
        color_idx = Set()
        while length(color_idx) < number_changes_local_search
            push!(color_idx, rand(palette_range))
        end
        color_idx_vector = collect(color_idx)

        #new colors to be added
        colors = Set()
        while length(colors) < number_changes_local_search
            push!(colors, possible_colors[select_from_pizza(pizza)])
        end
        colors = collect(colors)
        new_palette[color_idx_vector, :] = colors
        
        #recolor the image with the new palette
        for i in 1:size(img_matrix)[2]
            for j in 1:size(img_matrix)[3]
                if index_img[i, j] in color_idx
                    palette_img[:, i, j] = palette[index_img[i, j]]
                end
            end
        end

        #compute the distance and update the best image
        distance = f(palette_img)
        if distance < f_val
            f_val = distance
            best_img .= palette_img
        end
    end
    return best_img, f_val
end

function quantize(img_matrix, palette_img, index_img, possible_colors, pizza, palette_size)
    palette = create_palette(possible_colors, pizza, palette_size)
    palette_img, index_img = color_img(img_matrix, palette, palette_img, index_img)
    return palette_img, index_img, palette
end