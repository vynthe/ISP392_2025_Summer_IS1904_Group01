package chatbot;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.regex.Pattern;

@WebServlet("/ChatbotServlet")
public class GeminiChatServlet extends HttpServlet {
    private static final String API_KEY = "AIzaSyDzpsNtmWfBH4EE6EjxVho6D6ABY_02Phc";
    private static final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=" + API_KEY;
    
    // Enhanced Knowledge Base với scoring
    private static final Map<String, KnowledgeItem> KNOWLEDGE_BASE = new HashMap<>();
    
    static {
        // Implant knowledge
        KNOWLEDGE_BASE.put("implant", new KnowledgeItem(
            "Cấy ghép Implant",
            "🦷 **CẤY GHÉP IMPLANT TẠI PDC**\n\n" +
            "✨ **Công nghệ tiên tiến**: Implant Straumann (Thụy Sĩ), Nobel Biocare (Thụy Điển)\n" +
            "⏰ **Thời gian**: 3-6 tháng lành thương, có thể gắn răng tạm\n" +
            "💎 **Chất liệu**: Titanium grade 4 tương thích sinh học 100%\n" +
            "🏆 **Bảo hành**: 10 năm với chứng nhận quốc tế\n" +
            "💰 **Ưu đãi**: Tư vấn miễn phí + X-quang 3D + lập kế hoạch điều trị\n\n" +
            "**Quy trình 4 bước an toàn:**\n" +
            "1. Khám và chụp CT 3D đánh giá xương\n" +
            "2. Cấy implant bằng kỹ thuật không đau\n" +
            "3. Chờ lành thương 3-6 tháng\n" +
            "4. Gắn răng sứ thẩm mỹ cao",
            Arrays.asList("implant", "cấy ghép", "trồng răng", "mất răng", "răng giả", "titanium")
        ));
        
        KNOWLEDGE_BASE.put("nieng_rang", new KnowledgeItem(
            "Niềng răng - Chỉnh nha",
            "😊 **NIỀNG RĂNG CHỈNH NHA TẠI PDC**\n\n" +
            "🔧 **Các loại mắc cài**:\n" +
            "• **Kim loại**: Hiệu quả cao, giá hợp lý (15-25 triệu)\n" +
            "• **Sứ**: Thẩm mỹ tốt, màu răng tự nhiên (20-35 triệu)\n" +
            "• **Trong suốt**: Invisalign, thẩm mỹ tuyệt đối (40-80 triệu)\n" +
            "• **Mắc cài tự buộc**: Giảm thời gian điều trị 30%\n\n" +
            "⏳ **Thời gian**: 18-24 tháng (tùy mức độ)\n" +
            "📅 **Tái khám**: Mỗi 4-6 tuần\n" +
            "🎯 **Độ tuổi**: Từ 7 tuổi đến 50+ tuổi\n" +
            "💡 **Ưu điểm**: Công nghệ 3D, bác sĩ chỉnh nha chuyên khoa 15+ năm kinh nghiệm",
            Arrays.asList("niềng", "mắc cài", "chỉnh nha", "răng khấp khểnh", "răng hô", "răng móm", "invisalign")
        ));
        
        KNOWLEDGE_BASE.put("tre_em", new KnowledgeItem(
            "Nha khoa trẻ em",
            "👶 **NHA KHOA TRẺ EM CHUYÊN NGHIỆP**\n\n" +
            "🏥 **Phòng khám thân thiện**: Trang trí hoạt hình, âm nhạc nhẹ nhàng\n" +
            "👨‍⚕️ **Đội ngũ**: Bác sĩ nha khoa nhi chuyên khoa\n" +
            "🎈 **Phương pháp**: Không đau, không sợ hãi\n" +
            "📅 **Độ tuổi**: Từ 6 tháng - 16 tuổi\n\n" +
            "**Dịch vụ chính:**\n" +
            "• Khám định kỳ 6 tháng/lần\n" +
            "• Trám răng sữa bằng composite thẩm mỹ\n" +
            "• Bôi Fluor phòng sâu răng\n" +
            "• Nhổ răng sữa không đau\n" +
            "• Chỉnh nha sớm (7-12 tuổi)\n" +
            "• Tư vấn chế độ ăn và vệ sinh răng miệng",
            Arrays.asList("trẻ em", "bé", "nhi", "răng sữa", "sâu răng", "trẻ", "con", "fluor")
        ));
        
        KNOWLEDGE_BASE.put("phauthuat", new KnowledgeItem(
            "Phẫu thuật xương hàm",
            "🏥 **PHẪU THUẬT XƯƠNG HÀM CHỈNH HÌNH**\n\n" +
            "🎯 **Điều trị**: Hô, móm, lệch hàm, cười hở lợi\n" +
            "🔬 **Công nghệ**: Mô phỏng 3D trước phẫu thuật\n" +
            "👨‍⚕️ **Đội ngũ**: Phẫu thuật viên hàm mặt kinh nghiệm 20+ năm\n" +
            "⏰ **Thời gian**: 2-3 giờ, hồi phục 2-4 tuần\n" +
            "🏨 **Cơ sở**: Phòng mổ đạt chuẩn quốc tế\n\n" +
            "**Quy trình:**\n" +
            "1. Khám và chụp CT 3D\n" +
            "2. Lập kế hoạch phẫu thuật 3D\n" +
            "3. Phẫu thuật chỉnh xương\n" +
            "4. Theo dõi và chăm sóc sau mổ",
            Arrays.asList("phẫu thuật", "xương hàm", "hô", "móm", "lệch hàm", "hàm mặt", "chỉnh hình")
        ));
        
        KNOWLEDGE_BASE.put("tham_my", new KnowledgeItem(
            "Nha khoa thẩm mỹ",
            "✨ **NHA KHOA THẨM MỸ ĐẲNG CẤP**\n\n" +
            "🦷 **Tẩy trắng răng**:\n" +
            "• Tẩy trắng tại phòng khám: 1 buổi, trắng 8-10 tone\n" +
            "• Tẩy trắng tại nhà: 2 tuần, an toàn tuyệt đối\n\n" +
            "💎 **Veneer sứ siêu mỏng**: 0.3mm, không mài răng nhiều\n" +
            "👑 **Bọc răng sứ**: Zirconia, Emax, bảo hành 5 năm\n" +
            "😊 **Cười Hollywood**: Thiết kế nụ cười theo tỷ lệ vàng\n" +
            "💋 **Bọc răng nanh**: Chỉnh sửa răng nanh nhọn\n\n" +
            "**Cam kết**: Thẩm mỹ tự nhiên, hài hòa khuôn mặt",
            Arrays.asList("thẩm mỹ", "tẩy trắng", "veneer", "bọc sứ", "răng đẹp", "nụ cười", "hollywood", "sứ")
        ));
        
        KNOWLEDGE_BASE.put("nho_rang", new KnowledgeItem(
            "Nhổ răng khôn",
            "🦷 **NHỔ RĂNG KHÔN AN TOÀN**\n\n" +
            "📋 **Chỉ định nhổ**: Mọc lệch, đau nhức, sâu răng, viêm lợi\n" +
            "📸 **Chẩn đoán**: X-quang 3D Cone Beam CT chính xác 100%\n" +
            "💉 **Vô cảm**: Gây tê cục bộ, không đau\n" +
            "⚡ **Kỹ thuật**: Siêu âm Piezosurgery, ít chấn thương\n" +
            "🩹 **Hồi phục**: 3-5 ngày, thuốc giảm đau đầy đủ\n\n" +
            "**Quy trình:**\n" +
            "1. Khám lâm sàng + X-quang\n" +
            "2. Tư vấn phương án nhổ\n" +
            "3. Nhổ răng với công nghệ hiện đại\n" +
            "4. Hướng dẫn chăm sóc sau nhổ",
            Arrays.asList("nhổ răng khôn", "răng khôn", "nhổ răng", "đau răng", "viêm lợi", "mọc lệch")
        ));
        
        KNOWLEDGE_BASE.put("gia_cuoc", new KnowledgeItem(
            "Bảng giá dịch vụ",
            "💰 **BẢNG GIÁ THAM KHẢO NHA KHOA PDC**\n\n" +
            "🦷 **Implant**: 20-35 triệu/răng (bao gồm trụ + răng sứ)\n" +
            "😊 **Niềng răng**: 15-80 triệu (tùy loại mắc cài)\n" +
            "👶 **Nha khoa trẻ em**: 200k-2 triệu (tùy dịch vụ)\n" +
            "🏥 **Phẫu thuật hàm**: 50-150 triệu (tùy mức độ)\n" +
            "✨ **Thẩm mỹ**: 2-25 triệu (tùy dịch vụ)\n" +
            "🦷 **Nhổ răng khôn**: 500k-3 triệu (tùy độ khó)\n\n" +
            "🎁 **Ưu đãi hiện tại**:\n" +
            "• Tư vấn + X-quang miễn phí\n" +
            "• Trả góp 0% lãi suất\n" +
            "• Giảm 10% cho khách hàng mới",
            Arrays.asList("giá", "chi phí", "bảng giá", "tiền", "cost", "phí", "ưu đãi", "trả góp")
        ));
        
        KNOWLEDGE_BASE.put("lien_he", new KnowledgeItem(
            "Thông tin liên hệ",
            "📞 **THÔNG TIN LIÊN HỆ NHA KHOA PDC**\n\n" +
            "🏥 **Chi nhánh chính**: \n" +
            "📍 123 Nguyễn Văn Linh, Q.7, TP.HCM\n" +
            "☎️ Hotline: 1900-1234\n" +
            "📱 Zalo: 0901-234-567\n\n" +
            "🏥 **Chi nhánh 2**: \n" +
            "📍 456 Lê Văn Việt, Q.9, TP.HCM\n" +
            "☎️ Tel: 028-3456-7890\n\n" +
            "⏰ **Giờ làm việc**: Thứ 2 - Chủ nhật (8:00 - 20:00)\n" +
            "🌐 **Website**: www.nhakhoapdc.com\n" +
            "📧 **Email**: info@nhakhoapdc.com\n" +
            "📅 **Đặt lịch online**: Có sẵn 24/7",
            Arrays.asList("địa chỉ", "liên hệ", "hotline", "ở đâu", "contact", "phone", "zalo", "email", "website")
        ));
    }
    
    // Knowledge Item class để lưu trữ thông tin
    static class KnowledgeItem {
        String title;
        String content;
        List<String> keywords;
        
        KnowledgeItem(String title, String content, List<String> keywords) {
            this.title = title;
            this.content = content;
            this.keywords = keywords;
        }
        
        // Tính điểm relevance
        double calculateRelevance(String userMessage) {
            String message = userMessage.toLowerCase();
            double score = 0.0;
            
            for (String keyword : keywords) {
                if (message.contains(keyword.toLowerCase())) {
                    score += 1.0;
                    // Bonus cho exact match
                    if (message.equals(keyword.toLowerCase())) {
                        score += 0.5;
                    }
                }
            }
            
            // Fuzzy matching bonus
            for (String keyword : keywords) {
                if (fuzzyMatch(message, keyword.toLowerCase())) {
                    score += 0.3;
                }
            }
            
            return score;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        
        try {
            String requestBody = getRequestBody(request);
            System.out.println("📥 Received request: " + requestBody);
            
            if (requestBody == null || requestBody.trim().isEmpty()) {
                sendErrorResponse(out, gson, "Request body trống", "Empty request");
                return;
            }
            
            JsonObject requestData = gson.fromJson(requestBody, JsonObject.class);
            String userMessage = requestData.get("message").getAsString().trim();
            
            System.out.println("💬 User message: " + userMessage);
            
            // RAG Pipeline: Retrieve relevant knowledge
            List<KnowledgeItem> relevantKnowledge = retrieveRelevantKnowledge(userMessage);
            
            String aiResponse;
            try {
                if (!relevantKnowledge.isEmpty()) {
                    // Dùng RAG với context từ knowledge base
                    aiResponse = callGoogleAIWithRAG(userMessage, relevantKnowledge);
                } else {
                    // Fallback to general context
                    aiResponse = callGoogleAIGeneral(userMessage);
                }
                System.out.println("🤖 AI Response: " + aiResponse);
            } catch (Exception e) {
                System.err.println("❌ AI API Error: " + e.getMessage());
                // Enhanced fallback with RAG
                aiResponse = getEnhancedFallbackResponse(userMessage, relevantKnowledge);
                System.out.println("🔄 Using enhanced fallback: " + aiResponse);
            }
            
            // Lưu chat history
            saveChatHistory(request, userMessage, aiResponse);
            
            JsonObject responseJson = new JsonObject();
            responseJson.addProperty("success", true);
            responseJson.addProperty("response", aiResponse);
            responseJson.addProperty("confidence", calculateConfidence(userMessage, relevantKnowledge));
            
            out.print(gson.toJson(responseJson));
            out.flush();
            
        } catch (Exception e) {
            System.err.println("💥 Servlet Error: " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(out, gson, "Lỗi hệ thống", "System error: " + e.getMessage());
        }
    }
    
    // Enhanced RAG: Retrieve relevant knowledge
    private List<KnowledgeItem> retrieveRelevantKnowledge(String userMessage) {
        List<KnowledgeItem> results = new ArrayList<>();
        
        for (KnowledgeItem item : KNOWLEDGE_BASE.values()) {
            double relevance = item.calculateRelevance(userMessage);
            if (relevance > 0) {
                results.add(item);
            }
        }
        
        // Sort by relevance score
        results.sort((a, b) -> Double.compare(b.calculateRelevance(userMessage), a.calculateRelevance(userMessage)));
        
        // Return top 3 most relevant
        return results.subList(0, Math.min(3, results.size()));
    }
    
    // RAG-enhanced AI call
    private String callGoogleAIWithRAG(String userMessage, List<KnowledgeItem> relevantKnowledge) throws IOException {
        StringBuilder context = new StringBuilder();
        context.append("Bạn là trợ lý ảo chuyên nghiệp của Nha Khoa PDC. ");
        context.append("Dựa vao thông tin sau để trả lời chính xác và hữu ích:\n\n");
        
        for (KnowledgeItem item : relevantKnowledge) {
            context.append("=== ").append(item.title).append(" ===\n");
            context.append(item.content).append("\n\n");
        }
        
        context.append("Câu hỏi của khách hàng: ").append(userMessage);
        context.append("\n\nHãy trả lời một cách thân thiện, chuyên nghiệp và chi tiết.");
        
        return callGoogleAI(context.toString());
    }
    
    // General AI call without RAG
    private String callGoogleAIGeneral(String userMessage) throws IOException {
        String context = "Bạn là trợ lý ảo của Nha Khoa PDC - 'Giải pháp tối ưu, can thiệp tối thiểu'. " +
                "Chuyên về: Implant, Niềng răng, Nha khoa trẻ em, Phẫu thuật hàm mặt, Thẩm mỹ nha khoa, Nhổ răng khôn. " +
                "Trả lời thân thiện, chuyên nghiệp bằng tiếng Việt.\n\nCâu hỏi: " + userMessage;
        
        return callGoogleAI(context);
    }
    
    // Enhanced fallback with RAG knowledge
    private String getEnhancedFallbackResponse(String userMessage, List<KnowledgeItem> relevantKnowledge) {
        if (!relevantKnowledge.isEmpty()) {
            // Return most relevant knowledge
            KnowledgeItem bestMatch = relevantKnowledge.get(0);
            return bestMatch.content + "\n\n💡 *Để biết thêm thông tin chi tiết, bạn có thể liên hệ hotline 1900-1234 để được tư vấn miễn phí.*";
        }
        
        // Smart fallbacks based on message patterns
        String message = userMessage.toLowerCase();
        
        if (containsAny(message, "xin chào", "hello", "hi", "chào")) {
            return "👋 Xin chào! Tôi là trợ lý ảo của Nha Khoa PDC. Tôi có thể hỗ trợ bạn về:\n\n" +
                   "🦷 Cấy ghép Implant\n😊 Niềng răng chỉnh nha\n👶 Nha khoa trẻ em\n🏥 Phẫu thuật hàm mặt\n✨ Nha khoa thẩm mỹ\n🦷 Nhổ răng khôn\n\n" +
                   "Bạn quan tâm dịch vụ nào? Tôi sẽ tư vấn chi tiết cho bạn! 😊";
        }
        
        if (containsAny(message, "cảm ơn", "thank", "thanks")) {
            return "🙏 Rất vui được hỗ trợ bạn! Nha Khoa PDC luôn sẵn sàng tư vấn miễn phí 24/7. Chúc bạn một ngày tốt lành! 😊";
        }
        
        if (containsAny(message, "tạm biệt", "bye", "goodbye")) {
            return "👋 Tạm biệt! Cảm ơn bạn đã quan tâm đến Nha Khoa PDC. Hẹn gặp lại bạn sớm nhé! 😊";
        }
        
        // Default intelligent response
        return "🤔 Tôi hiểu bạn đang quan tâm về vấn đề răng miệng. Mặc dù tôi chưa có thông tin cụ thể về câu hỏi này, " +
               "nhưng đội ngũ bác sĩ chuyên khoa của PDC sẽ tư vấn chi tiết cho bạn.\n\n" +
               "📞 **Liên hệ ngay**: 1900-1234\n" +
               "💬 **Hoặc hỏi tôi về**: Implant, Niềng răng, Nha khoa trẻ em, Phẫu thuật, Thẩm mỹ, Nhổ răng khôn\n\n" +
               "Bạn có câu hỏi nào khác tôi có thể hỗ trợ không? 😊";
    }
    
    // Helper methods
    private boolean containsAny(String text, String... keywords) {
        for (String keyword : keywords) {
            if (text.contains(keyword)) return true;
        }
        return false;
    }
    
    private static boolean fuzzyMatch(String text, String keyword) {
        // Simple fuzzy matching - can be enhanced with Levenshtein distance
        if (keyword.length() < 3) return false;
        return text.contains(keyword.substring(0, Math.min(3, keyword.length())));
    }
    
    private double calculateConfidence(String userMessage, List<KnowledgeItem> relevantKnowledge) {
        if (relevantKnowledge.isEmpty()) return 0.3;
        
        double maxRelevance = relevantKnowledge.get(0).calculateRelevance(userMessage);
        return Math.min(0.95, 0.5 + (maxRelevance * 0.1));
    }
    
    private void saveChatHistory(HttpServletRequest request, String userMessage, String aiResponse) {
        @SuppressWarnings("unchecked")
        List<String> chatHistory = (List<String>) request.getSession().getAttribute("chatHistory");
        if (chatHistory == null) {
            chatHistory = new ArrayList<>();
            request.getSession().setAttribute("chatHistory", chatHistory);
        }
        
        chatHistory.add("Bạn: " + userMessage);
        chatHistory.add("PDC Bot: " + aiResponse);
        
        // Keep only last 20 messages
        if (chatHistory.size() > 20) {
            chatHistory = new ArrayList<>(chatHistory.subList(chatHistory.size() - 20, chatHistory.size()));
            request.getSession().setAttribute("chatHistory", chatHistory);
        }
    }
    
    // Core Google AI call method
    private String callGoogleAI(String context) throws IOException {
        URL url = new URL(API_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setDoOutput(true);
        conn.setConnectTimeout(30000);
        conn.setReadTimeout(30000);
        
        JsonObject requestBody = new JsonObject();
        JsonArray contents = new JsonArray();
        JsonObject content = new JsonObject();
        JsonArray parts = new JsonArray();
        JsonObject part = new JsonObject();
        
        part.addProperty("text", context);
        parts.add(part);
        content.add("parts", parts);
        contents.add(content);
        requestBody.add("contents", contents);
        
        // Generation config for better responses
        JsonObject generationConfig = new JsonObject();
        generationConfig.addProperty("temperature", 0.8);
        generationConfig.addProperty("maxOutputTokens", 2048);
        generationConfig.addProperty("topP", 0.9);
        generationConfig.addProperty("topK", 40);
        requestBody.add("generationConfig", generationConfig);
        
        // Send request
        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = requestBody.toString().getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }
        
        // Read response
        int responseCode = conn.getResponseCode();
        InputStream inputStream = (responseCode == 200) ? conn.getInputStream() : conn.getErrorStream();
        
        StringBuilder response = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line.trim());
            }
        }
        
        if (responseCode != 200) {
            throw new IOException("API Error " + responseCode + ": " + response.toString());
        }
        
        // Parse response
        Gson gson = new Gson();
        JsonObject responseJson = gson.fromJson(response.toString(), JsonObject.class);
        
        if (responseJson.has("candidates")) {
            JsonArray candidates = responseJson.getAsJsonArray("candidates");
            if (candidates.size() > 0) {
                JsonObject candidate = candidates.get(0).getAsJsonObject();
                if (candidate.has("content")) {
                    JsonObject contentObj = candidate.getAsJsonObject("content");
                    if (contentObj.has("parts")) {
                        JsonArray partsArray = contentObj.getAsJsonArray("parts");
                        if (partsArray.size() > 0) {
                            JsonObject partObj = partsArray.get(0).getAsJsonObject();
                            if (partObj.has("text")) {
                                return partObj.get("text").getAsString().trim();
                            }
                        }
                    }
                }
            }
        }
        
        throw new IOException("Invalid response structure");
    }
    
    private String getRequestBody(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        return sb.toString();
    }
    
    private void sendErrorResponse(PrintWriter out, Gson gson, String userMessage, String errorDetails) {
        JsonObject errorResponse = new JsonObject();
        errorResponse.addProperty("success", false);
        errorResponse.addProperty("response", "Xin lỗi, " + userMessage + ". Vui lòng thử lại sau hoặc liên hệ hotline 1900-1234.");
        errorResponse.addProperty("error", errorDetails);
        
        out.print(gson.toJson(errorResponse));
        out.flush();
    }
}