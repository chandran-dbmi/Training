library(QoRTs);

args <- commandArgs(trailingOnly = TRUE)
if(length(args) == 3){
   base.dir <- args[1];
   decoder <- args[2];
   output.dir <- args[3];
}

#message("READING QC FILES...");
print("biotype");
res <- read.qc.results.data(base.dir, decoder.files = decoder,
                                   calc.DESeq2 = deseqReq, calc.edgeR = edgeRReq);
print("finished");
#message("DONE WITH FILE READING");

byLane.plotter = build.plotter.colorByLane(res);
byGroup.plotter = build.plotter.colorByGroup(res);
bySample.plotter = build.plotter.colorBySample(res);

#makePlot.biotype.rates(byLane.plotter);

png(file.path(output.dir, "biotypeByLane.png"))
makePlot.biotype.rates(byLane.plotter, showTypes = c("rRNA","Mt_rRNA"))
dev.off()

png(file.path(output.dir, "biotypeByGroup.png"))
makePlot.biotype.rates(byGroup.plotter, showTypes = c("rRNA","Mt_rRNA"))
dev.off()

png(file.path(output.dir, "biotypeBySample.png"),width=600)
par(mar=c(5.1, 4.1, 4.1, 13.1), xpd=TRUE)
makePlot.biotype.rates(bySample.plotter, showTypes = c("rRNA","Mt_rRNA","protein_coding"))
makePlot.legend.over("bottomright",bySample.plotter, inset=c(-0.5,0));
dev.off()




