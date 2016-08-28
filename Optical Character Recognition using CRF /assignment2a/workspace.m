wfgn = textread('model/feature-params.txt');
wtgn = textread('model/transition-params.txt');

%wfgn = reshape(wfgn,[321,10]);
%wfgn = wfgn';
wfgn = reshape(wfgn,[1, size(wfgn,1)*size(wfgn,2)]);

%wtgn = reshape(wtgn,[10,10]);
%wtgn = wtgn';
wtgn = reshape(wtgn,[1, size(wtgn,1)*size(wtgn,2)]);

wgn = [wfgn wtgn];

message_passing(wgn');
test_inference(wgn');
%msg_pass_test(wgn);

