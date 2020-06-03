load 'gl2'
coinsert 'jgl2'

WINDOW=: 'game'

W=: 500
H=: 300
BRICK_W=: 50
BRICK_H=: 20
BRICK_SIZE=: BRICK_W,BRICK_H
PADDLE_W=: 100
PADDLE_H=: 10
PADDLE_SIZE=: PADDLE_W,PADDLE_H
BALL_R=: 5
BALL_D=: 2*BALL_R

paddle_x=: <.W%3

NB. upper-left corner of ball
ball_xy=: (paddle_x + ?(PADDLE_W - BALL_D)) , (H - PADDLE_H) - BALL_D
ball_v=: 1

draw_window=: verb define
  wd 'pc ',(":WINDOW),' closebutton;'
  wd 'cc canvas isidraw flush;'
  wd 'setp wh ',(":W),' ',(":H),';'
  wd 'pshow;'
)

game_close=: verb define
  wd 'psel ',":WINDOW
  wd 'pclose;'
  wd 'timer 0;'
)

draw_brick_at=: verb define
  glbrush glrgb ?3$255
  glrect y , BRICK_W , BRICK_H
)

draw_bricks=: verb define
  x=. BRICK_W * i.<.W % BRICK_W
  y=. BRICK_H * i.<.(<. H % 3) % BRICK_H
  xy=. ,/ x (,"0/) y
  draw_brick_at"1 xy
)

draw_paddle=: verb define
  glbrush glrgb 100 100 100
  glrect paddle_x , (H - PADDLE_H) , PADDLE_W , PADDLE_H
)

draw_ball=: verb define
  glbrush glrgb 200 200 200
  glellipse ball_xy , BALL_D , BALL_D
)

main=: verb define
  NB. close previously created window if any
  game_close^:wdisparent WINDOW

  draw_window ''
  draw_bricks ''
  draw_paddle ''
  draw_ball ''
)

main ''