%% Get Standarized Character Images, and place them in a matrix
nchars = 52;
character_list = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
im_matrix = [];
labels = [];
k = 10;
data = cell(nchars);
for i = 1:nchars
    char = draw_string_modified(character_list(i));
    wid = size(char, 2);
    char = char(5:end-2,0.5*wid-60:0.5*wid+60);
    wid = size(char, 2);
    hei = size(char, 1);
    char = reshape(char, wid*hei, 1);
    im_matrix = [im_matrix, char];
    labels = [labels, character_list(i)];
    data{i} = char;
end
%% Perform PCA to find eigencharacters
mean_char = [];
for row = 1:size(im_matrix, 1)
    mu = mean(im_matrix(row, :));
    mean_char = [mean_char; mu];
end
T = im_matrix - mean_char;
C = T'*T;
[U,D] = eig(C);
eigval = diag(D);
eigval = eigval(end:-1:1);
V = [];
hold on;
for j = 1:6
    subplot(3,2,j)
    v_temp = T*U(:,j);
    v = v_temp./norm(v_temp);
    V = [V, v];
    imshow(reshape(v_temp+mean_char, hei, wid))
    pause(1)
end
pause(5)
hold off;
%% Find weight vectors
weight_matrix = [];
for i = 1:size(im_matrix,2)
    test_char = im_matrix(:,i); 
    phi = test_char - mean_char;
    omega = V'*phi;
    imshow(reshape(V*omega+mean_char, hei, wid))
    weight_matrix = [weight_matrix, omega];
    pause(1)
end
