function [Dh, Dl] = rand_select_dict(Xh, Xl, dict_size)

addpath(genpath('RegularizedSC'));

hDim = size(Xh, 1);
lDim = size(Xl, 1);

% should pre-normalize Xh and Xl !
hNorm = sqrt(sum(Xh.^2));
lNorm = sqrt(sum(Xl.^2));
Idx = find( hNorm & lNorm );

Xh = Xh(:, Idx);
Xl = Xl(:, Idx);

Xh = Xh./repmat(sqrt(sum(Xh.^2)), size(Xh, 1), 1);
Xl = Xl./repmat(sqrt(sum(Xl.^2)), size(Xl, 1), 1);

P = randperm(size(Xh, 2));
Dh = Xh(:, P);
Dl = Xl(:, P);
Dh = Dh(:, 1:dict_size);
Dl = Dl(:, 1:dict_size);

% dict_path = ['Dictionary_new/D_' num2str(dict_size) '_' num2str(lambda) '_' num2str(patch_size) '_s' num2str(upscale) '.mat' ];
dict_path = 'Dictionary_new/rand_dict.mat';
save(dict_path, 'Dh', 'Dl');