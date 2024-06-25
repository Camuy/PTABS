function volume = volcalc(stl, x)
x = real(x);
obj.vertices = stl.Points;
obj.faces = stl.ConnectivityList;

    volume = 0;
    for i = 1:size(obj.faces, 1)
        v1 = obj.vertices(obj.faces(i, 1), :);
        v2 = obj.vertices(obj.faces(i, 2), :);
        v3 = obj.vertices(obj.faces(i, 3), :);
        if v1(3) > x || v2(3) > x || v3(3) > x
            if v1(3) > x
                v1(3) = x;
            end
            if v2(3) > x
                v2(3) = x;
            end
            if v3(3) > x
                v3(3) = x;
            end

        end

        volume = volume + dot(v1, cross(v2, v3))/6;
        
    end
    volume = abs(volume);
end


