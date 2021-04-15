# Login Presenter

## Regras
1. ✅ Chamar validation ao alterar o email
2. ✅ Notificar o emailErrorStream com o mesmo erro do Validation, caso retorne erro
3. ✅ Notificar o emailErrorStream com null, caso o Validation não retorne erro
4. ✅ Não notificar o emailErrorStream se o valor for igual ao último
5. ✅ Notificar o isFormValidStream após alterar o email
6. ✅ Chamar Validation ao alterar a senha
7. ✅ Notificar o passwordErrorStream com o mesmo erro do Validation, caso retorne erro
8. ✅ Notificar o passwordErrorStream com null, caso o Validation não retorne erro
9. ✅ Não notificar o passwordErrorStream se o valor for igual ao último
10. ✅ Notificar o isFormValidStream após alterar a senha
11. ✅ Para o formulário estar valido todos os streams de erro precisam estar null e todos os campos obrigatórios não podem estar vazios
12. ✅ Não notificar o isFormValidStream se o valor for igual ao último
13. ✅ Chamar o authentication com o email e senha corretos
14. ✅ Notificar o isLoadingStream como true antes de chamar o authentication
15. ✅ Notificar o isLoadingStream com false no fim do authentication
16. ✅ Notificar o mainErrorStream caso o authentication retorne um DomainError
17. ✅ Fechar todos os streams no dispose
18. 🛑 Gravar o account no cache em caso de Sucesso
19. 🛑 Levar o usuário para tela de enquetes em caso de sucesso.
