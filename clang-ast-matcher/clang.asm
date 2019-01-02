000000000001e850 <main>:
   1e850:	55                   	push   %rbp
   1e851:	48 89 e5             	mov    %rsp,%rbp
   1e854:	48 81 ec 80 01 00 00 	sub    $0x180,%rsp
   1e85b:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
   1e862:	00 00 
   1e864:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
   1e868:	c7 85 9c fe ff ff 00 	movl   $0x0,-0x164(%rbp)
   1e86f:	00 00 00 
   1e872:	89 bd 98 fe ff ff    	mov    %edi,-0x168(%rbp)
   1e878:	48 89 b5 90 fe ff ff 	mov    %rsi,-0x170(%rbp)
   1e87f:	0f 57 c0             	xorps  %xmm0,%xmm0
   1e882:	0f 29 85 a0 fe ff ff 	movaps %xmm0,-0x160(%rbp)
   1e889:	48 8d bd a0 fe ff ff 	lea    -0x160(%rbp),%rdi
   1e890:	e8 1b a5 00 00       	callq  28db0 <clang::ast_matchers::MatchFinder::MatchFinderOptions::MatchFinderOptions()>

   // By comparing with the assembly generated with g++,
   // it seems that this instruction should be:
   //     lea    -0x160(%rbp),%rsi
   // to make %rsi non-zero.
   //
   // Otherwise in the constructor of MatchFinder reading
   // memory 0x8(%rsi) results in segmentation fault.
   1e895:	48 8b b5 a0 fe ff ff 	mov    -0x160(%rbp),%rsi
   1e89c:	8b 95 a8 fe ff ff    	mov    -0x158(%rbp),%edx
   1e8a2:	48 8d 85 b0 fe ff ff 	lea    -0x150(%rbp),%rax
   1e8a9:	48 89 c7             	mov    %rax,%rdi
   1e8ac:	48 89 85 88 fe ff ff 	mov    %rax,-0x178(%rbp)
   1e8b3:	e8 a8 f9 ff ff       	callq  1e260 <clang::ast_matchers::MatchFinder::MatchFinder(clang::ast_matchers::MatchFinder::MatchFinderOptions)@plt>
   1e8b8:	c7 85 9c fe ff ff 00 	movl   $0x0,-0x164(%rbp)
   1e8bf:	00 00 00 
   1e8c2:	48 8b bd 88 fe ff ff 	mov    -0x178(%rbp),%rdi
   1e8c9:	e8 f2 fb ff ff       	callq  1e4c0 <clang::ast_matchers::MatchFinder::~MatchFinder()@plt>
   1e8ce:	8b 85 9c fe ff ff    	mov    -0x164(%rbp),%eax
   1e8d4:	64 48 8b 34 25 28 00 	mov    %fs:0x28,%rsi
   1e8db:	00 00 
   1e8dd:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
   1e8e1:	48 39 fe             	cmp    %rdi,%rsi
   1e8e4:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%rbp)
   1e8ea:	0f 85 0f 00 00 00    	jne    1e8ff <main+0xaf>
   1e8f0:	8b 85 84 fe ff ff    	mov    -0x17c(%rbp),%eax
   1e8f6:	48 81 c4 80 01 00 00 	add    $0x180,%rsp
   1e8fd:	5d                   	pop    %rbp
   1e8fe:	c3                   	retq   
