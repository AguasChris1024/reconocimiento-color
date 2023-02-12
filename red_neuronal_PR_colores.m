
% Dividir los datos en dos grupos: entrenamiento y testeo
train_data = load ('train_data.mat');
train_inputs = train_data.train_data(:,1:end-1);
train_targets = train_data.train_data(:,end);
test_data = load('test_data.mat');
test_inputs = test_data.test_data(:,1:end-1);
test_targets = test_data.test_data(:,end);



% Definir la estructura de la red neuronal
input_layer_size = size(train_inputs, 1);
hidden_layer_size = 10;
num_labels = size(train_targets, 1);

% Inicializar los pesos aleatoriamente
Theta1 = rand(hidden_layer_size, input_layer_size + 1) * 2 * 0.12 - 0.12;
Theta2 = rand(num_labels, hidden_layer_size + 1) * 2 * 0.12 - 0.12;


% Configurar las opciones de entrenamiento
num_iterations = 1000;
learning_rate = 0.1;

% Entrenar la red neuronal
for i = 1:num_iterations
    % Realizar una propagación hacia adelante
    a1 = [ones(size(train_inputs, 2), 1), train_inputs'];
    z2 = Theta1 * a1';
    a2 = [ones(1, size(z2, 2)); sigmoid(z2)];
    z3 = Theta2 * a2;
    a3 = sigmoid(z3);

    % Calcular el error
    delta3 = a3 - train_targets';
    delta2 = (Theta2' * delta3) .* [ones(1, size(z2, 2)); sigmoidGradient(z2)];
    delta2 = delta2(2:end, :);

    % Actualizar los pesos
    Theta1_grad = delta2 * a1 / size(train_inputs, 2);
    Theta2_grad = delta3 * a2' / size(train_inputs, 2);
    Theta1 = Theta1 - learning_rate * Theta1_grad;
    Theta2 = Theta2 - learning_rate * Theta2_grad;
end

% Realizar predicciones en datos de prueba
a1 = [ones(size(test_inputs, 2), 1), test_inputs'];
z2 = Theta1 * a1';a2 = [ones(1, size(z2, 2)); sigmoid(z2)];
z3 = Theta2 * a2;
a3 = sigmoid(z3);

predictions = a3 > 0.5;

% Calcular la precisión de la red
accuracy = mean(double(predictions == test_targets')) * 100;
fprintf('La precisión de la red es del %f%%\n', accuracy);