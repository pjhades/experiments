load 'plot'
load 'numeric'

ellipse =: 4 : 0
t =. steps 0 2p1 1000
px =. x * 1 o. t
py =. y * 2 o. t
px;py
)