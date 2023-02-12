%% Limpieza de workspace
clc
close all
clear all

%% Inicialización de parámetros
% data
load .\dataSetColores\modeloEntrenamientoColoresknn.mat
X = dataset.train.imagenes(:,:);
L = dataset.train.labels(:,1);
N = length(dataset.train.imagenes(:,1));

% K value
K = floor(round(log10(N)));
if(mod(K,2) == 0)
    K = K+1;
end

%% Input
a = 1;
b = length(dataset.test.imagenes);
red = randi([a b],1);
imgTest = dataset.test.imagenes(red,:);
labelTest = dataset.test.labels(red, 1);

%% Distance calc (euclidean)
distance = zeros(length(X),3);
for i=1: length(X)
    distance(i,1) = sum(sqrt((X(i,:)-imgTest(1,:)).^2));
    distance(i,2) = L(i,1);
    distance(i,3) = i;
end

%% Sort distances
[~, s] = sort(distance(:, 1));
ord = distance(s, :);
%% Get k short values
kVector = zeros(K,3);
for i = 1: K
    kVector(i,:) = ord(i,:);
end

%% Get Answer
[cnt_unique, unique_a] = histogram(kVector(:,2),unique(kVector(:,2)));
unique_a(:,2) = cnt_unique(:)*100/K; 

mayor = false;
res = unique_a(1,2);
for i = 1 : size(unique_a,1)
    if(unique_a(i,2) > res)
        res = unique_a(i,1);
        mayor = true;
        break
    end
end

if(mayor)
    a = find(kVector(:,2) == res);
    res = kVector(a(1),:);
else
    res = kVector(1,:);
end

%% test
subplot(1,2,1)
imshow(reshape(imgTest,[28,28]));
title("Imagen de entrada");
xlabel("Etiqueta: "+labelTest);

subplot(1,2,2)
imshow(reshape(X(res(1,3),:),[28,28]))
title("Predicción");
xlabel("Etiqueta asignada: "+res(1,2))