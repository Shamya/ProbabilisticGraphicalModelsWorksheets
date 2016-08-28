% function evaluations
addpath(genpath(pwd));

%initialize weight - to given params for faster convergence assuming closer to optima
wfgn = textread('model/feature-params.txt');
wtgn = textread('model/transition-params.txt');
wfgn = reshape(wfgn,[1, size(wfgn,1)*size(wfgn,2)]);
wtgn = reshape(wtgn,[1, size(wtgn,1)*size(wtgn,2)]);
w0 = [wfgn wtgn];

%options
options = [];
options.Method = 'lbfgs';
options.Display = 'iter';

fun = @message_passing;
[wbest,fval] = minFunc(fun,w0',options);
fprintf('fval = %.4f (minFunc with LBFGS)\n',fval);
fprintf('---------------------------------------\n');

err = test_inference(wbest);
fprintf('Test error = %.4f',err);

%permute to the new character combination and plot old and new
keySet =   {'e', 't', 'a', 'i', 'n', 'o', 's', 'h', 'r', 'd'};
valueSet = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
mapObj = containers.Map(keySet,valueSet);

keySetNew = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
valueSetNew =   {'e', 'a', 'i', 'o', 't', 'n', 's', 'h', 'r', 'd'};
mapObjNew = containers.Map(keySetNew,valueSetNew);

wt_actual = reshape(wbest(3211:end),[10,10]);

%get parameters in new ordering
wt_new = zeros(10,10);

for l = 1:10
    a = mapObjNew(l);
    b = mapObj(a);
    wt_new(l,:) = wt_actual(b,:);
end

wt_temp = wt_new;
for l = 1:10
    a = mapObjNew(l);
    b = mapObj(a);
    wt_new(:,l) = wt_temp(:,b);
end

%plot actual
figure(1)
imagesc(wt_actual);
set(gca,'xtick',1:10,'ytick',1:10, 'XAxisLocation', 'top')
set(gca,'xticklabel',keySet,'yticklabel',keySet)
title('Q3.1 Learnt transistion paramter in original oredering')
colormap gray;
colorbar;

%plot new
figure(2)
imagesc(wt_new);
set(gca,'xtick',1:10,'ytick',1:10, 'XAxisLocation', 'top')
set(gca,'xticklabel',valueSetNew,'yticklabel',valueSetNew)
title('Q3.2 Learnt transistion paramter in new oredering with vowels first')
colormap gray;
colorbar;