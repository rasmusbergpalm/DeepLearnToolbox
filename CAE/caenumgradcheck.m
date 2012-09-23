function cae = caenumgradcheck(cae, x, y)
    epsilon = 1e-4;
    er = 1e-6;
    disp('performing numerical gradient checking...')
    for i = 1 : numel(cae.o)
        p_cae = cae; p_cae.c{i} = p_cae.c{i} + epsilon;
        m_cae = cae; m_cae.c{i} = m_cae.c{i} - epsilon;

        [m_cae, p_cae] = caerun(m_cae, p_cae, x, y);
        d = (p_cae.L - m_cae.L) / (2 * epsilon);

        e = abs(d - cae.dc{i});
        if e > er
            disp('OUTPUT BIAS numerical gradient checking failed');
            disp(e);
            disp(d / cae.dc{i});
            keyboard
        end
    end

    for a = 1 : numel(cae.a)

        p_cae = cae; p_cae.b{a} = p_cae.b{a} + epsilon;
        m_cae = cae; m_cae.b{a} = m_cae.b{a} - epsilon;

        [m_cae, p_cae] = caerun(m_cae, p_cae, x, y);
        d = (p_cae.L - m_cae.L) / (2 * epsilon);
%        cae.dok{i}{a}(u) = d;
        e = abs(d - cae.db{a});
        if e > er
            disp('BIAS numerical gradient checking failed');
            disp(e);
            disp(d / cae.db{a});
            keyboard
        end

        for i = 1 : numel(cae.o)
            for u = 1 : numel(cae.ok{i}{a})
                p_cae = cae; p_cae.ok{i}{a}(u) = p_cae.ok{i}{a}(u) + epsilon;
                m_cae = cae; m_cae.ok{i}{a}(u) = m_cae.ok{i}{a}(u) - epsilon;

                [m_cae, p_cae] = caerun(m_cae, p_cae, x, y);
                d = (p_cae.L - m_cae.L) / (2 * epsilon);
%                cae.dok{i}{a}(u) = d;
                e = abs(d - cae.dok{i}{a}(u));
                if e > er
                    disp('OUTPUT KERNEL numerical gradient checking failed');
                    disp(e);
                    disp(d / cae.dok{i}{a}(u));
%                    keyboard
                end
            end
        end

        for i = 1 : numel(cae.i)
            for u = 1 : numel(cae.ik{i}{a})
                p_cae = cae; 
                m_cae = cae;
                p_cae.ik{i}{a}(u) = p_cae.ik{i}{a}(u) + epsilon;
                m_cae.ik{i}{a}(u) = m_cae.ik{i}{a}(u) - epsilon;
                [m_cae, p_cae] = caerun(m_cae, p_cae, x, y);
                d = (p_cae.L - m_cae.L) / (2 * epsilon);
%                cae.dik{i}{a}(u) = d;
                e = abs(d - cae.dik{i}{a}(u));
                if e > er
                    disp('INPUT KERNEL numerical gradient checking failed');
                    disp(e);
                    disp(d / cae.dik{i}{a}(u));
                end
            end
        end
    end

    disp('done')

end

function [m_cae, p_cae] = caerun(m_cae, p_cae, x, y)
    m_cae = caeup(m_cae, x); m_cae = caedown(m_cae); m_cae = caebp(m_cae, y);
    p_cae = caeup(p_cae, x); p_cae = caedown(p_cae); p_cae = caebp(p_cae, y);
end

%function checknumgrad(cae,what,x,y)
%    epsilon = 1e-4;
%    er = 1e-9;
%
%    for i = 1 : numel(eval(what))
%        if iscell(eval(['cae.' what]))
%            checknumgrad(cae,[what '{' num2str(i) '}'], x, y)
%        else
%            p_cae = cae;
%            m_cae = cae;
%            eval(['p_cae.' what '(' num2str(i) ')']) = eval([what '(' num2str(i) ')']) + epsilon;
%            eval(['m_cae.' what '(' num2str(i) ')']) = eval([what '(' num2str(i) ')']) - epsilon;
%
%            m_cae = caeff(m_cae, x); m_cae = caedown(m_cae); m_cae = caebp(m_cae, y);
%            p_cae = caeff(p_cae, x); p_cae = caedown(p_cae); p_cae = caebp(p_cae, y);
%
%            d = (p_cae.L - m_cae.L) / (2 * epsilon);
%            e = abs(d - eval(['cae.d' what '(' num2str(i) ')']));
%            if e > er
%                error('numerical gradient checking failed');
%            end
%         end
%     end
%
% end
