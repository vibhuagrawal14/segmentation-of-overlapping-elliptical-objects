function [] = toExcel( filename, numbers, sheet,xlRange1,xlRange2,A)
xlswrite(filename,A,sheet,xlRange1);
xlswrite(filename,numbers,sheet,xlRange2);
end

