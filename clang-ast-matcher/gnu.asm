000000000001d759 <main>:
   1d759:	55                   	push   %rbp
   1d75a:	48 89 e5             	mov    %rsp,%rbp
   1d75d:	53                   	push   %rbx
   1d75e:	48 81 ec 78 01 00 00 	sub    $0x178,%rsp
   1d765:	89 bd 8c fe ff ff    	mov    %edi,-0x174(%rbp)
   1d76b:	48 89 b5 80 fe ff ff 	mov    %rsi,-0x180(%rbp)
   1d772:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
   1d779:	00 00 
   1d77b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
   1d77f:	31 c0                	xor    %eax,%eax
   1d781:	48 c7 85 90 fe ff ff 	movq   $0x0,-0x170(%rbp)
   1d788:	00 00 00 00 
   1d78c:	48 c7 85 98 fe ff ff 	movq   $0x0,-0x168(%rbp)
   1d793:	00 00 00 00 
   1d797:	48 8d 85 90 fe ff ff 	lea    -0x170(%rbp),%rax
   1d79e:	48 89 c7             	mov    %rax,%rdi
   1d7a1:	e8 28 b1 00 00       	callq  288ce <clang::ast_matchers::MatchFinder::MatchFinderOptions::MatchFinderOptions()>
   1d7a6:	48 8d 95 90 fe ff ff 	lea    -0x170(%rbp),%rdx
   1d7ad:	48 8d 85 a0 fe ff ff 	lea    -0x160(%rbp),%rax
   1d7b4:	48 89 d6             	mov    %rdx,%rsi
   1d7b7:	48 89 c7             	mov    %rax,%rdi

   1d7ba:	e8 a1 fa ff ff       	callq  1d260 <clang::ast_matchers::MatchFinder::MatchFinder(clang::ast_matchers::MatchFinder::MatchFinderOptions)@plt>
   1d7bf:	48 8d 85 90 fe ff ff 	lea    -0x170(%rbp),%rax
   1d7c6:	48 89 c7             	mov    %rax,%rdi
   1d7c9:	e8 1c b1 00 00       	callq  288ea <clang::ast_matchers::MatchFinder::MatchFinderOptions::~MatchFinderOptions()>
   1d7ce:	bb 00 00 00 00       	mov    $0x0,%ebx
   1d7d3:	48 8d 85 a0 fe ff ff 	lea    -0x160(%rbp),%rax
   1d7da:	48 89 c7             	mov    %rax,%rdi
   1d7dd:	e8 de fc ff ff       	callq  1d4c0 <clang::ast_matchers::MatchFinder::~MatchFinder()@plt>
   1d7e2:	89 d8                	mov    %ebx,%eax
   1d7e4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
   1d7e8:	64 48 33 0c 25 28 00 	xor    %fs:0x28,%rcx
   1d7ef:	00 00 
   1d7f1:	74 24                	je     1d817 <main+0xbe>
   1d7f3:	eb 1d                	jmp    1d812 <main+0xb9>
   1d7f5:	48 89 c3             	mov    %rax,%rbx
   1d7f8:	48 8d 85 90 fe ff ff 	lea    -0x170(%rbp),%rax
   1d7ff:	48 89 c7             	mov    %rax,%rdi
   1d802:	e8 e3 b0 00 00       	callq  288ea <clang::ast_matchers::MatchFinder::MatchFinderOptions::~MatchFinderOptions()>
   1d807:	48 89 d8             	mov    %rbx,%rax
   1d80a:	48 89 c7             	mov    %rax,%rdi
   1d80d:	e8 ee f9 ff ff       	callq  1d200 <_Unwind_Resume@plt>
   1d812:	e8 e9 f8 ff ff       	callq  1d100 <__stack_chk_fail@plt>
   1d817:	48 81 c4 78 01 00 00 	add    $0x178,%rsp
   1d81e:	5b                   	pop    %rbx
   1d81f:	5d                   	pop    %rbp
   1d820:	c3                   	retq   
