function sortHistoryByTime

global History;
for i = 1:length(History)-1;
    disp(length(History)-i);
    for j = 1:length(History)-i;
        if later( History(j).vmTime,History(j+1).vmTime );
            temp = History(j);
            History(j) = History(j+1);
            History(j+1) = temp;
            disp( [ '����������� ',num2str(j),' �� ',num2str(j+1) ] );
        end
    end
end