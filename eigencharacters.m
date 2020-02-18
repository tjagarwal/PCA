%% Get Standarized Character Images, and place them in a matrix
nchars = 52;
character_list = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
im_matrix = [];
data = cell(i);
for i = 1:nchars
    char = draw_string_modified(character_list(i));
    wid = size(char, 2);
    char = char(5:end-2,0.5*wid-60:0.5*wid+60);
    wid = size(char, 2);
    hei = size(char, 1);
    % imshow(char)
    char = reshape(char, wid*hei, 1);
    im_matrix = [im_matrix, char];
    data{i} = char;
end
%% Perform PCA
mean_char = [];
for row = 1:size(im_matrix, 1)
    mu = mean(im_matrix(row, :));
    mean_char = [mean_char; mu];
end
imshow(reshape(mean_char, hei, wid))  
pause(5)

[U, ~, ~, ~, E] = pca(im_matrix);
cumvar = 0;
i = 0;
PCs = [];
while cumvar < 80
    i = i + 1;
    PCs = [PCs, U(:,i)];
    cumvar = cumvar + E(i);
end
disp('Total Variance in the first '+string(i)+' Components = '+string(cumvar))
new_images = im_matrix*PCs;
%% Uncollapse Images
for j = 1:i
    imshow(reshape(mean_char+new_images(:,j), hei, wid))
    pause(3)
end
eigenchars = new_images+mean_char;
b = data{2};
x = eigenchars\b;
