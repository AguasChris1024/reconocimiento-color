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
    img = im2double(img);

  
    % Obtener el gradiente
    Gx = [-1 1];
    Gy = Gx';
    Ix = conv2(img,Gx,'same');
    Iy = conv2(img,Gy,'same');

    % Definir el sistema de inferencia con lógica difusa para la
    % detección de bordes
    edgeFIS = mamfis('Name', 'edgeDetection');

    % Agregado de los gradientes de la imagen como entradas a edgeFIS
    edgeFIS = addInput(edgeFIS,[-1 1],'Name','Ix');
    edgeFIS = addInput(edgeFIS,[-1 1],'Name','Iy');

    % Especificar el zero-mean Gaussiano para cada entrada
    sx = 0.09; % desviación estándar - Valores a modificar para mejorar
    sy = 0.09; % la exactitud del modelo
    edgeFIS = addMF(edgeFIS,'Ix','gaussmf',[sx 0],'Name','zero');
    edgeFIS = addMF(edgeFIS,'Iy','gaussmf',[sy 0],'Name','zero');
    edgeFIS = addOutput(edgeFIS,[0 1],'Name','Iout');

    wa = 0.1;
    wb = 1;
    wc = 1;
    ba = 0;
    bb = 0;
    bc = 0.7;
    edgeFIS = addMF(edgeFIS,'Iout','trimf',[wa wb wc],'Name','white');
    edgeFIS = addMF(edgeFIS,'Iout','trimf',[ba bb bc],'Name','black');
    
    regla1 = "If Ix is zero and Iy is zero then Iout is white";
    regla2 = "If Ix is not zero or Iy is not zero then Iout is black";
    edgeFIS = addRule(edgeFIS,[regla1 regla2]);
    edgeFIS.Rules
    
    Ieval = zeros(size(img));
    for i = 1:size(img,1)
        Ieval(i,:) = evalfis(edgeFIS,[(Ix(i,:));(Iy(i,:))]');
    end

    % Eliminar objetos con tamaño menor a x pixeles
    edges = bwareaopen(Ieval, 400);

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

figure
image(img,'CDataMapping','scaled')
colormap('gray')
title('Imagen original en escala de grises')

figure
image(Ieval,'CDataMapping','scaled')
colormap('gray')
title('Detección de bordes usando lógica difusa')
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




