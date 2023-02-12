clc
close all
clear all 


cam = webcam(1);
wb = waitbar(0,'-','Name','Espera..','CreateCancelBtn','delete(gcbf)');
i=0;
while true
    % Capturar imagen de la cámara web
    recuadro = snapshot(cam);
    img = im2gray(recuadro);

  
    % Aplicar filtro Gaussiano para suavizar la imagen
    img = imgaussfilt(img, 2);

    % Detectar bordes con Canny
    edgesCanny = edge(img, 'canny', [0.1, 0.2]);

    % Detectar bordes con Laplaciano
    edgesLaplacian = edge(img, 'log');

    % Combinar bordes detectados por Canny y Laplaciano
    edges = edgesCanny | edgesLaplacian;

    % Eliminar objetos con tamaño menor a x pixeles
    edges = bwareaopen(edges, 1000);

    % Encuadrar objetos
    stats = regionprops(edges, 'BoundingBox','Image');

    % Dibujar rectángulos alrededor de los objetos
    imshow(recuadro);
    hold on;
    for j = 1:length(stats)
       
        imgTest=imcrop(recuadro,stats(j).BoundingBox);
        imgTest = imresize(imgTest,[25 25]);
        imgTest = im2double(imgTest);
        imgTest= reshape(imgTest,1,[]);
        YPredicha = myNeuralNetworkFunctionColors(imgTest);
        [~, indice] = max(YPredicha);
        clase = indice - 1;
        etiqueta = clase + 1;
        Color='color';
        switch etiqueta
                case 1
                    Color = "Amarillo";
                case 2
                    Color = "Azul";
                case 3
                    Color = "Blanco";
                case 4
                    Color = "Celeste";
                case 5
                    Color = "Gris";
                case 6
                    Color = "Morado";
                case 7
                    Color = "Naranja";
                case 8
                    Color = "Negro";
                case 9
                    Color = "Rojo";
                case 10
                    Color = "Verde";
                otherwise
                    app.COLOREditField.Value = "Indeterminado";   
        end
        h = rectangle('Position', stats(j).BoundingBox, 'LineWidth', 2, 'EdgeColor', 'g', 'Tag', 'MyRectangle');
        rect_pos = get(h,'Position');
        text(rect_pos(1)+rect_pos(3)/2, rect_pos(2)+rect_pos(4)/2,Color , 'Color', 'red', 'FontSize', 14, 'HorizontalAlignment', 'center');

    end
    hold off;
%____________________________________________________    
    if ~ishandle(wb)
        break
    else
        waitbar(i/10,wb,['num: '  num2str(i)]);
    end
%_____________________________________________________
i=i+1;
    pause(0.01);
end
clear cam;



