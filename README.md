# chat_diabetes

O Chat Diabetes é um chatbot para ajudar pacientes com diabetes no seu dia a dia.

Aluno: Lucas Menezes Costa 202000066884

Ferramentas utilizadas:

- Flutter/Dart
- Google Gemini para o chat
- Api Google speech to text para reconhecimento de fala
- Bing para gerar a logo (edição no photoshop)
- Deploy no Amplify da AWS

Mensagem que é enviada juntamente em todas as mensagens: "Este chat se tratará apenas de conversas sobre diabetes. Este paciente é um paciente diabético que precisa tirar dúvidas sobre tudo relacionado a diabetes, ele também pode tirar dúvidas sobre outras coisas relacionadas a saúde que também se relacionam com a diabetes e também sobre alimentos para diabéticos portanto, caso a pergunta do não seja relacionada a diabetes, informe que não irá responder (lembrando que tudo que você disser são apenas sugestões com base no seu conhecimento). A pergunta é a seguinte (não responda nada que esteja ecrito até aqui):"

Com isso, o chat responderá apenas perguntas sobre diabetes. A biblioteca do gemini no Flutter atualmente não está suportando fine-tuning.

O Flutter foi escolhido pois é o primeiro a receber suporte ao gemini, por ser do próprio Google.

Link da aplicação: https://main.d197u96wye60ev.amplifyapp.com/
