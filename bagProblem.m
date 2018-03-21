function bagProblem

Bag.content = 5;
Bag.amount = 1;

Items(1).weight = 1;
Items(1).value = 60;
Items(1).amount = 1;

Items(2).weight = 2;
Items(2).value = 100;
Items(2).amount = 1;

Items(3).weight = 3;
Items(3).value = 120;
Items(3).amount = 1;

% Items(4).weight = 5;
% Items(4).value = 4;
% Items(4).amount = 1;
% 
% Items(5).weight = 4;
% Items(5).value = 6;
% Items(5).amount = 1;

Putin = zeros( 1,Bag.content+1 );

for i = 1:length(Items)
    for j = Bag.content:-1:Items(i).weight;
        try
            if Putin(j-Items(i).weight+1) + Items(i).value > Putin(j+1);
                Putin(j+1) = Putin(j-Items(i).weight+1) + Items(i).value;
                disp(i);
            end
        catch
            1;
        end
    end
end

Putin
