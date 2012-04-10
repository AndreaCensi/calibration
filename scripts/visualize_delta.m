function visualize_delta(a,b,variables)
    visualize_delta1(a,b,1:6)
    visualize_delta1(a,b,7:10)

function visualize_delta1(a,b,variables)
    nexp = numel(a);
    n = numel(a{1}.x);

    for i=1:nexp
        xa = a{i}.x;
        xb = b{i}.x;
        

        fprintf('%13s/%13s & ', a{i}.basename, b{i}.basename);

        for k=variables

            ratio = xa(k)/xb(k);
            if ratio > 1.5
                % oops, the same problem with radius multiplied by 2
                ratio = ratio / 2;
            end
            fprintf('%.5f ', ratio);
            if k < variables(end)
                fprintf('& ')
            else
                fprintf('\\')
            end

        end
        fprintf('\n');
    end


