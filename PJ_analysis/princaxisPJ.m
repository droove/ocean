function thp=princaxisPJ(u,v);
% eq. 4.1 in Kundu_P_K et al_1976@JPO_some three dimensional characteristics of low frequency current fluctuations near the oregon coast
% thp range =[-180 180] deg. from east CCW
up=u-nanmean(u);
vp=v-nanmean(v);
upvpbar=nanmean((up).*(vp));
upb2vpb2=nanmean(up.^2)-nanmean(vp.^2);
thp=atan2(2*upvpbar,upb2vpb2)/2*180/pi;

