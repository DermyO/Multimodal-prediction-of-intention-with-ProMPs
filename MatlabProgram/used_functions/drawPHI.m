function drawPHI(promp,M, s_bar, col)
%function to plot the pondered RBFs

%TODO pour l'instant script pour mon code avec 3 type de données et intervalles définit. 

%TODODevra être généralisé pour tout type de promp.

PhiX = promp.PHI_norm(1:s_bar , 1:M(1));
PhiY = promp.PHI_norm(s_bar+1:2*s_bar , M(1)+1:M(1)+M(2));
PhiZ = promp.PHI_norm(s_bar*2+1:3*s_bar , M(1)+M(2)+1:M(1)+2*M(2));


subplot(3,1,1);hold on;

plot((PhiX'.*promp.mu_w(1:M(1)))', col);
%axis([1 14 0 500]);

subplot(3,1,2);hold on;
plot((PhiY'.*promp.mu_w(M(1)+1:M(1)+M(2)))', col);
%axis([1 14 0 500]);

subplot(3,1,3);hold on;
plot((PhiZ'.*promp.mu_w(M(1)+M(2)+1:2*M(2)+M(1)))', col);
%axis([1 14 -2 2]);

end