function npow = noisepow(nbw, nf, reftemp)
% nbw: Bandwidth [Hz]
% nf: Noise figure [dB]
% reftemp: Reference noise temperature [K]
% npow: Noise power [W]

npow = 1.38064852e-23 * reftemp * (db2pow(nf) - 1) * nbw;

end

