function pae = paenumgradcheck(pae,x,y)
    epsilon = 1e-4;
    er = 1e-6;
    disp('performing numerical gradient checking...')
    for i=1:numel(pae.o)
        p_pae = pae; p_pae.c{i} = p_pae.c{i} + epsilon;
        m_pae = pae; m_pae.c{i} = m_pae.c{i} - epsilon;

        [m_pae, p_pae] = paerun(m_pae, p_pae, x, y);
        d = (p_pae.L - m_pae.L)/(2*epsilon);

        e = abs(d - pae.dc{i});
        if(e > er)
            disp('OUTPUT BIAS numerical gradient checking failed');
            disp(e);
            disp(d/pae.dc{i});
            keyboard
        end
    end
    for a=1:numel(pae.a)
        
        p_pae = pae; p_pae.b{a} = p_pae.b{a} + epsilon;
        m_pae = pae; m_pae.b{a} = m_pae.b{a} - epsilon;

        [m_pae, p_pae] = paerun(m_pae, p_pae, x, y);
        d = (p_pae.L - m_pae.L)/(2*epsilon);
%                 pae.dok{i}{a}(u) = d;
        e = abs(d - pae.db{a});
        if(e > er)
            disp('BIAS numerical gradient checking failed');
            disp(e);
            disp(d/pae.db{a});
            keyboard
        end
            
        
        for i=1:numel(pae.o)
            for u=1:numel(pae.ok{i}{a})
                p_pae = pae; p_pae.ok{i}{a}(u) = p_pae.ok{i}{a}(u) + epsilon;
                m_pae = pae; m_pae.ok{i}{a}(u) = m_pae.ok{i}{a}(u) - epsilon;


                [m_pae, p_pae] = paerun(m_pae, p_pae, x, y);
                d = (p_pae.L - m_pae.L)/(2*epsilon);
%                 pae.dok{i}{a}(u) = d;
                e = abs(d - pae.dok{i}{a}(u));
                if(e > er)
                    disp('OUTPUT KERNEL numerical gradient checking failed');
                    disp(e);
                    disp(d/pae.dok{i}{a}(u));
%                     keyboard
                end
            end
        end
        for i=1:numel(pae.i)
            for u=1:numel(pae.ik{i}{a})
                p_pae = pae; 
                m_pae = pae;
                p_pae.ik{i}{a}(u) = p_pae.ik{i}{a}(u) + epsilon;
                m_pae.ik{i}{a}(u) = m_pae.ik{i}{a}(u) - epsilon;
                [m_pae, p_pae] = paerun(m_pae, p_pae, x, y);
                d = (p_pae.L - m_pae.L)/(2*epsilon);
%                 pae.dik{i}{a}(u) = d;
                e = abs(d - pae.dik{i}{a}(u));
                if(e > er)
                    disp('INPUT KERNEL numerical gradient checking failed');
                    disp(e);
                    disp(d/pae.dik{i}{a}(u));
                end
            end
        end
        
    end
    
    disp('done')

end

function [m_pae, p_pae]=paerun(m_pae, p_pae, x, y)
    m_pae = paeup(m_pae,x); m_pae = paedown(m_pae); m_pae = paebp(m_pae,y);
    p_pae = paeup(p_pae,x); p_pae = paedown(p_pae); p_pae = paebp(p_pae,y);
end

% function checknumgrad(pae,what,x,y)
%     epsilon = 1e-4;
%     er = 1e-9;
%     
%     for i=1:numel(eval(what))
%         if(iscell(eval(['pae.' what])))
%             checknumgrad(pae,[what '{' num2str(i) '}'], x, y)
%         else
%             p_pae = pae;
%             m_pae = pae;
%             eval(['p_pae.' what '(' num2str(i) ')']) = eval([what '(' num2str(i) ')']) + epsilon;
%             eval(['m_pae.' what '(' num2str(i) ')']) = eval([what '(' num2str(i) ')']) - epsilon;
%             
%             m_pae = paeff(m_pae,x); m_pae = paedown(m_pae); m_pae = paebp(m_pae,y);
%             p_pae = paeff(p_pae,x); p_pae = paedown(p_pae); p_pae = paebp(p_pae,y);
%             
%             d = (p_pae.L - m_pae.L)/(2*epsilon);
%             e = abs(d - eval(['pae.d' what '(' num2str(i) ')']));
%             if(e > er)
%                 error('numerical gradient checking failed');
%             end
%             
%         end
%     end
%             
%   
% end