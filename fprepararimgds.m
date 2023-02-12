function [imgpreparada] = prepararimgds(img)
    img = im2double(img);
    img = reshape(img,1,[]);
    imgpreparada = img;
end