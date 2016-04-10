passo=100
for j=1:length(u)
    u{j}=u{j}(1:passo:end);
end
y=y(1:passo:end);