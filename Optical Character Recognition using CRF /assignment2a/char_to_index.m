function l = char_to_index(label, mapObj)
sz = size(label,2);
l = [];
for c = 1:sz
    l = [l int8(mapObj(label(c)))];
end
end

