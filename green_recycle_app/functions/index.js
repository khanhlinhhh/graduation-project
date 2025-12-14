const functions = require("firebase-functions");
const admin = require("firebase-admin");
const fetch = require("node-fetch");

admin.initializeApp();

// System prompt for GreenBot - CHỈ trả lời về phân loại rác
const SYSTEM_PROMPT = `Bạn là GreenBot - trợ lý phân loại rác của ứng dụng Green Recycle.

🎯 NHIỆM VỤ DUY NHẤT: Hỗ trợ người dùng về phân loại rác và tái chế.

✅ BẠN CHỈ ĐƯỢC TRẢ LỜI các câu hỏi về:
- Cách phân loại rác (tái chế ♻️, hữu cơ 🥬, nguy hại ☢️, thông thường 🗑️)
- Vật liệu nào có thể tái chế (nhựa, giấy, kim loại, thủy tinh...)
- Cách xử lý rác nguy hại (pin, bóng đèn, thuốc hết hạn...)
- Điểm thu gom rác tái chế
- Mẹo giảm thiểu rác thải

❌ TỪ CHỐI LỊCH SỰ các câu hỏi KHÔNG liên quan đến rác/tái chế như:
- Toán học, lập trình, công nghệ
- Tin tức, thời sự, giải trí
- Sức khỏe, y tế (trừ rác thải y tế)
- Mọi chủ đề khác không liên quan

Khi nhận câu hỏi không liên quan, trả lời: "Xin lỗi, tôi chỉ có thể hỗ trợ về phân loại rác và tái chế thôi ạ! 🌿 Bạn có câu hỏi nào về rác không?"

📝 QUY TẮC:
- Luôn trả lời bằng tiếng Việt
- Ngắn gọn, dễ hiểu (tối đa 3-4 câu)
- Sử dụng emoji phù hợp
- Thân thiện và nhiệt tình`;

/**
 * Chatbot Cloud Function - Callable
 * Receives messages array and returns AI response
 * 
 * Input: { messages: [{role: "user"|"assistant", content: "..."}] }
 * Output: { text: "AI response" }
 */
exports.chatbot = functions
  .runWith({
    secrets: ["GEMINI_API_KEY"],
    timeoutSeconds: 60,
    memory: "256MB",
  })
  .https.onCall(async (data, context) => {
    // 1. Check authentication
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "Bạn phải đăng nhập để sử dụng chatbot."
      );
    }

    // 2. Validate input
    const { messages } = data;
    if (!messages || !Array.isArray(messages)) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Dữ liệu không hợp lệ. Cần có mảng messages."
      );
    }

    // Validate each message
    for (const msg of messages) {
      if (!msg.role || !msg.content) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Mỗi tin nhắn phải có role và content."
        );
      }
      if (!["user", "assistant", "system"].includes(msg.role)) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Role phải là user, assistant hoặc system."
        );
      }
    }

    // 3. Get API key from secrets
    const apiKey = process.env.GEMINI_API_KEY;
    if (!apiKey) {
      console.error("GEMINI_API_KEY not configured");
      throw new functions.https.HttpsError(
        "internal",
        "Lỗi cấu hình server. Vui lòng liên hệ admin."
      );
    }

    try {
      // 4. Convert messages to Gemini format
      const geminiContents = [];

      // Add system prompt as first exchange
      geminiContents.push({
        role: "user",
        parts: [{ text: SYSTEM_PROMPT }]
      });
      geminiContents.push({
        role: "model",
        parts: [{ text: "Tôi hiểu rồi! Tôi là GreenBot, sẵn sàng giúp bạn về phân loại rác và bảo vệ môi trường. 🌿♻️" }]
      });

      // Add conversation history
      for (const msg of messages) {
        if (msg.role === "system") continue; // Skip system messages (already handled)
        geminiContents.push({
          role: msg.role === "user" ? "user" : "model",
          parts: [{ text: msg.content }]
        });
      }

      // 5. Call Gemini API
      const response = await fetch(
        `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${apiKey}`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            contents: geminiContents,
            generationConfig: {
              temperature: 0.7,
              topK: 40,
              topP: 0.95,
              maxOutputTokens: 1024,
            }
          }),
        }
      );

      if (!response.ok) {
        const errorData = await response.json();
        console.error("Gemini API error:", errorData);
        throw new functions.https.HttpsError(
          "internal",
          "Lỗi kết nối AI. Vui lòng thử lại."
        );
      }

      const result = await response.json();

      // 6. Extract text from response
      const text = result.candidates?.[0]?.content?.parts?.[0]?.text;
      if (!text) {
        console.error("Invalid Gemini response:", result);
        throw new functions.https.HttpsError(
          "internal",
          "Không nhận được phản hồi từ AI."
        );
      }

      // 7. Log for monitoring (optional)
      console.log(`User ${context.auth.uid} sent ${messages.length} messages`);

      return { text };

    } catch (error) {
      // Handle unexpected errors
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      console.error("Unexpected error:", error);
      throw new functions.https.HttpsError(
        "internal",
        "Đã xảy ra lỗi không mong muốn. Vui lòng thử lại."
      );
    }
  });
