return { //ENTRY
  "if":function(){
    if($b_con){
      $true
    }
    else{
      $false
    }
  },
  "for_in":function(){
    for(let $item in $object){
      $body
    }
  },
  "compare":function(){
    $a != $b
  }
  // if(b_con){ //b_con (0 != 0x000000)
  //   if(b_con){ //b_con ("any" instanceOf new Function("return classss")())
  //     for(let item in object){
        
  //     }
  //   }
  // } 
  // return 1
  // else{ }
}
// 1.占位符等待流完成，替换