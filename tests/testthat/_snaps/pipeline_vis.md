# pipeline_vis success

    Code
      network <- pipeline_vis()
      network[["x"]][c("nodes", "edges")]
    Output
      $nodes
                 id level   color                                  title      label
      1    somedata     5 #ffb612    somedata<br>type:data<br>tag:no_tag   somedata
      2  staticdata     5 #ffb612 staticdata<br>type:other<br>tag:no_tag staticdata
      3       obj_A     4 #ca005d         obj_A<br>type:object<br>tag:t0      obj_A
      4       obj_B     3 #552c6f         obj_B<br>type:object<br>tag:t1      obj_B
      5       obj_E     3 #76d2b6         obj_E<br>type:object<br>tag:t2      obj_E
      6       obj_F     2 #007bc7       obj_F<br>type:object<br>tag:<NA>      obj_F
      7       obj_C     2 #76d2b6         obj_C<br>type:object<br>tag:t2      obj_C
      8       obj_G     2 #e17000         obj_G<br>type:object<br>tag:t3      obj_G
      9       obj_H     1 #007bc7       obj_H<br>type:object<br>tag:<NA>      obj_H
      10      obj_D     1 #76d2b6         obj_D<br>type:object<br>tag:t2      obj_D
           shape    tag
      1   square no_tag
      2  diamond no_tag
      3      dot     t0
      4      dot     t1
      5      dot     t2
      6      dot   <NA>
      7      dot     t2
      8      dot     t3
      9      dot   <NA>
      10     dot     t2
      
      $edges
          from         to   color title
      1  obj_A   somedata #ca005d    t0
      2  obj_A staticdata #ca005d    t0
      3  obj_B      obj_A #552c6f    t1
      4  obj_C      obj_B #76d2b6    t2
      5  obj_D staticdata #76d2b6    t2
      6  obj_D      obj_A #76d2b6    t2
      7  obj_D      obj_C #76d2b6    t2
      8  obj_F      obj_E #007bc7  <NA>
      9  obj_G      obj_E #e17000    t3
      10 obj_H      obj_F #007bc7  <NA>
      11 obj_H      obj_G #007bc7  <NA>
      

