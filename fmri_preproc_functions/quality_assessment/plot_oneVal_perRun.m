function plot_oneVal_perRun(meanVals,quality_name,qa_dir,ima_names)

quality_name_no_underscore = quality_name;
quality_name_no_underscore(findstr(quality_name_no_underscore,'_')) = ' ';

figure('visible','on');
set(gcf,'Position',[56         316        1791         735]);
plot([1:numel(meanVals)],[meanVals],'LineWidth',2,'Color',[.2 .2 .2]);
ylabel(quality_name_no_underscore);
xticks([1:numel(meanVals)]);
xticklabels(ima_names);
xtickangle(90);
xlabel('run #');
xlim([.5 numel(meanVals)+.5]);

title(quality_name_no_underscore);

saveas(gcf,[qa_dir,'qa_',quality_name,'.png']);
close(gcf);