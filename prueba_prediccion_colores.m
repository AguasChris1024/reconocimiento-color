load ("modelo_entrenado_dt.mat");
imgColores = imread("test_colores/verde/verde_24.jpg");
imgColoresPreparada = funcion_preparimgds(imgColores);


yfit = modelo_entrenado_dt.predictFcn(imgColoresPreparada); 
%view(modeloEntrenamientoDT.ClassificationTree, 'Mode', 'graph');