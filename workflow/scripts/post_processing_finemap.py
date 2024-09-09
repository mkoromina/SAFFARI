import glob
import pandas as pd 
import numpy as np
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-i','--input',dest='input',type=str,help="path to cleaned input files (as a directory). this assumes that the extension is *.gz and that the locus rsid is in the filename")
parser.add_argument('-o','--output',dest='output',type=str,help="path to where things go after (as a directory) . the convention will take the input and add _post_processes_results.txt after by default")
parser.add_argument('-p','--pip',dest='pip_thresh',type=float,default=0.5,help="threshold for pip (whereby snps > pip value are retained). the default is 0.5")



args = parser.parse_args()
mb=False
def make_df(files,thresh):

    for i,d in enumerate(files):
        if i==0:    
            df = pd.read_csv(d,sep='\t',compression='gzip')
            df['locus']=[d.split('.')[-2]] * df.shape[0]
        else:
            tmp = pd.read_csv(d,sep='\t',compression='gzip')
            tmp['locus'] = [d.split('.')[-2]] * tmp.shape[0]
            df=df._append(tmp)
    
    if 'noLD' not in files[0]:
    
        filt_df = df[(df['PIP'] >= thresh) & (df['CREDIBLE_SET']!=0)]
    else:
        filt_df = df[(df['PIP'] >=thresh)]
    locus_sizes_total=pd.DataFrame.from_dict({f"{i}":df[(df['CREDIBLE_SET']!=0) & (df['locus']==i)].shape[0] for i in df.locus.unique() if df[df['CREDIBLE_SET']!=0].shape[0] !=0},orient='index',columns=['snp_count'])
    mean_pip_per_locus=pd.DataFrame.from_dict({f"{i}":df[(df['CREDIBLE_SET']!=0) & (df['locus']==i)].PIP.mean() for i in df.locus.unique() if df[df['CREDIBLE_SET']!=0].shape[0] !=0},orient='index',columns=['mean_pip_per_locus'])
    return df, locus_sizes_total, mean_pip_per_locus, filt_df

files = glob.glob(f"{args.input}/*rs*.gz")
files = [i for i in files if 'all' not in i] # just to remove previous merged files from consideration 
if sum([1 if 'mb' in i else 0 for i in files]) != len(files):
    print('multiple mb windows present.')
    mb=True
if mb:
    reg_files = [i for i in files if 'mb' not in i]
    mb_files = [i for i in files if 'mb' in i]
    keys_mb = [i.split(".")[0].split('_')[-1] for i in mb_files]
    for k in np.unique(keys_mb):
        tmpfiles = [i for i in mb_files if i.split('.')[0].split('_')[-1] == k]
        df,locus_sizes_total,mean_pip_per_locus,filt_df=make_df(tmpfiles,args.pip_thresh)
        outname=tmpfiles[0].split('/')[-1].split('.')[0]
        df.to_csv(f"{args.output}/{outname}.merged.{k}.csv",index=True)
        filt_df.to_csv(f"{args.output}/{outname}.merged.filter.gt{args.pip_thresh}.{k}.csv",index=True)
        locus_sizes_total.to_csv(f"{args.output}/{outname}.locuscount.{k}.csv",index_label='locus')
        mean_pip_per_locus.to_csv(f"{args.output}/{outname}.locusmeanpip.{k}.csv",index_label='locus')
        print('outputs written')
    if len(reg_files) != 0:
        df,locus_sizes_total,mean_pip_per_locus,filt_df=make_df(reg_files,args.pip_thresh)
        outname=reg_files[0].split('/')[-1].split('.')[0]
        df.to_csv(f"{args.output}/{outname}.merged.csv",index=True)
        filt_df.to_csv(f"{args.output}/{outname}.merged.filter.gt{args.pip_thresh}.csv")
        locus_sizes_total.to_csv(f"{args.output}/{outname}.locuscount.csv",index_label='locus')
        mean_pip_per_locus.to_csv(f"{args.output}/{outname}.locusmeanpip.csv",index_label='locus')
        print('other outputs written')       
        # just need to get the outputs written 
else:
    df,locus_sizes_total,mean_pip_per_locus,filt_df=make_df(files,args.pip_thresh)
    outname=files[0].split('/')[-1].split('.')[0]
    df.to_csv(f"{args.output}/{outname}.merged.csv",index=True)
    filt_df.to_csv(f"{args.output}/{outname}.merged.filter.gt{args.pip_thresh}.csv",index=True)
    locus_sizes_total.to_csv(f"{args.output}/{outname}.locuscount.csv",index_label='locus')
    mean_pip_per_locus.to_csv(f"{args.output}/{outname}.locusmeanpip.csv",index_label='locus')
    print('outputs written')
