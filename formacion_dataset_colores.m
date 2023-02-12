%%
% Formación del data set
clc
close all
clear all 
colores = imageDatastore('dataSetColores\','IncludeSubfolders',true,'LabelSource','foldernames');
contador = 0;


while hasdata(colores)
    [imgColores,datos] = read(colores);
    %imshow(imgColores);
    imgColores = fprepararimgds(imgColores);
    contador = contador + 1;
    if(datos.Label == "amarillo")
        caracteristicas(contador,:) = imgColores;
        etiqueta(contador,1) = 1;
    elseif(datos.Label == "azul")
        caracteristicas(contador,:) = imgColores;
        etiqueta(contador,1) = 2;

    elseif(datos.Label == "blanco")
        caracteristicas(contador,:) = imgColores;
        etiqueta(contador,1) = 3;

    elseif(datos.Label == "celeste")
        caracteristicas(contador,:) = imgColores;
        etiqueta(contador,1) = 4;

    elseif(datos.Label == "gris")
        caracteristicas(contador,:) = imgColores;
        etiqueta(contador,1) = 5;

     elseif(datos.Label == "morado")
        caracteristicas(contador,:) = imgColores;
        etiqueta(contador,1) = 6;
        
     elseif(datos.Label == "naranja")
        caracteristicas(contador,:) = imgColores;
        etiqueta(contador,1) = 7;
        
      elseif(datos.Label == "negro")
        caracteristicas(contador,:) = imgColores;
        etiqueta(contador,1) = 8;
        
       elseif(datos.Label == "rojo")
        caracteristicas(contador,:) = imgColores;
        etiqueta(contador,1) = 9;
        
       elseif(datos.Label == "verde")
        caracteristicas(contador,:) = imgColores;
        etiqueta(contador,1) = 10;
         
    end
end

dataSetColores =  horzcat(caracteristicas,etiqueta);
    
%% 
% Manejo de las salidas para Red Neuronal de Reconocimiento de patrones
numclas=unique(etiqueta);
oneHotMat = (etiqueta ==1:length(numclas));

%%
% Entrenamiento de la Red Neuronal
train_data = load('train_data.mat');
train_inputs = train_data.train_data(:,1:end-1);
train_targets = train_data.train_data(:,end);
valorExactitud_train = 100 * (1 - mse(myNeuralNetworkFunctionColors(train_inputs), train_inputs, train_targets))
error_train = 100 - valorExactitud_train

% Testeo de la Red Neuronal entrenada
test_data = load('test_data.mat');
test_inputs = test_data.test_data(:,1:end-1);
test_targets = test_data.test_data(:,end);
valorExactitud = 100 * (1 - mse(myNeuralNetworkFunctionColors(test_inputs), test_inputs, test_targets))
error = 100 - valorExactitud
