return { //ENTRY
  "if":function(){
    // [UI类型]:[连接类型0/1/2]:[连通类型in/out]
    if(var0 = console.log()){
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
`# [[[__editor_des]]]
# [[节点]]
# [abc]
# type=UI类型
# flow=0(输入)/1(输出)/2(双端)/3(无，如某些只提供功能的按钮)
# slot=0(输入)/1(输出)/2(双端)/3(无，如某些只提供功能的按钮)
# ctx=左端的上下文
# ctx=右端的上下文
# [[des]]
# 1.本格式类似中间语言, 用于解释和构建基础节点类型
# 2.如果一个右端(slot=1)的插槽被视为input(flow=0)而非output, 说明这个插槽本身不产生任何输出, 只会等待/衔接另一个上下文
# 3.$表示递归获取上下文, 用于简化中间语言和规范写法
# 4."$[0/1 ,]"表示遍历所有输入/输出的上下文, 并用","分隔`
// 1.占位符等待流完成，替换