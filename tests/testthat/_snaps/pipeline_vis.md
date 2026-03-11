# pipeline_vis success

    Code
      network <- pipeline_vis()
      network[["x"]][c("nodes", "edges")]
    Output
      $nodes
                 id level   color                                  title      label
      1       obj_A     4 #ca005d         obj_A<br>type:object<br>tag:t0      obj_A
      2       obj_B     3 #552c6f         obj_B<br>type:object<br>tag:t1      obj_B
      3       obj_C     2 #76d2b6         obj_C<br>type:object<br>tag:t2      obj_C
      4       obj_D     1 #76d2b6         obj_D<br>type:object<br>tag:t2      obj_D
      5       obj_E     3 #76d2b6         obj_E<br>type:object<br>tag:t2      obj_E
      6       obj_F     2 #007bc7       obj_F<br>type:object<br>tag:<NA>      obj_F
      7       obj_G     2 #e17000         obj_G<br>type:object<br>tag:t3      obj_G
      8       obj_H     1 #007bc7       obj_H<br>type:object<br>tag:<NA>      obj_H
      9    somedata     5 #ffb612    somedata<br>type:data<br>tag:no_tag   somedata
      10 staticdata     5 #ffb612 staticdata<br>type:other<br>tag:no_tag staticdata
           shape    tag
      1      dot     t0
      2      dot     t1
      3      dot     t2
      4      dot     t2
      5      dot     t2
      6      dot   <NA>
      7      dot     t3
      8      dot   <NA>
      9   square no_tag
      10 diamond no_tag
      
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
      

