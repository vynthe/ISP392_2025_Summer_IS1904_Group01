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

/**
 * Servlet chính xử lý chatbot cho Nha Khoa PDC
 * Sử dụng Google Gemini AI API kết hợp với RAG (Retrieval-Augmented Generation)
 * để cung cấp thông tin chuyên nghiệp về các dịch vụ nha khoa
 */
@WebServlet("/ChatbotServlet")
public class GeminiChatServlet extends HttpServlet {
    // API key và URL để gọi Google Gemini AI
    private static final String API_KEY = "AIzaSyDzpsNtmWfBH4EE6EjxVho6D6ABY_02Phc";
    private static final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=" + API_KEY;
    
    // Cơ sở tri thức (Knowledge Base) chứa thông tin về các dịch vụ nha khoa
    private static final Map<String, KnowledgeItem> KNOWLEDGE_BASE = new HashMap<>();
    
    /**
     * Khối static khởi tạo cơ sở tri thức với các thông tin về dịch vụ nha khoa
     * Mỗi KnowledgeItem chứa: tiêu đề, nội dung chi tiết, và danh sách từ khóa
     */
    static {
        // Thông tin về dịch vụ cấy ghép Implant
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
        
        // Thông tin về dịch vụ niềng răng chỉnh nha
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
        
        // Thông tin về nha khoa trẻ em
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
        
        // Thông tin về phẫu thuật xương hàm
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
        
        // Thông tin về nha khoa thẩm mỹ
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
        
        // Thông tin về nhổ răng khôn
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
        
        // Thông tin về giá cả dịch vụ
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
        
        // Thông tin liên hệ
        KNOWLEDGE_BASE.put("lien_he", new KnowledgeItem(
            "Thông tin liên hệ",
            "📞 **THÔNG TIN LIÊN HỆ NHA KHOA PDC**\n\n" +
            "🏥 **Chi nhánh chính**: \n" +
            "📍 FPT Hòa Lạc, Thạch Thất, Hà Nội\n" +
            "☎️ Hotline: 0854321230\n" +
            "📱 Zalo: 0854321230\n\n" +
            "🏥 **Chi nhánh 1**: \n" +
            "⏰ **Giờ làm việc**: Thứ 2 - Thứ 7 (7:30 - 17:30)\n" +
            "🌐 **Website**: www.nhakhoapdc.com\n" +
            "📧 **Email**: nhakhoapdc@gmail.com\n" +
            "📅 **Đặt lịch online**: Có sẵn 24/7",
            Arrays.asList("địa chỉ", "liên hệ", "hotline", "ở đâu", "contact", "phone", "zalo", "email", "website")
        ));
    }
    
    /**
     * Lớp nội bộ đại diện cho một mục tri thức trong cơ sở dữ liệu
     * Chứa thông tin về một dịch vụ nha khoa cụ thể
     */
    static class KnowledgeItem {
        String title;           // Tiêu đề của dịch vụ
        String content;         // Nội dung chi tiết về dịch vụ
        List<String> keywords;  // Danh sách từ khóa liên quan
        
        /**
         * Constructor khởi tạo KnowledgeItem
         * @param title Tiêu đề dịch vụ
         * @param content Nội dung chi tiết
         * @param keywords Danh sách từ khóa
         */
        KnowledgeItem(String title, String content, List<String> keywords) {
            this.title = title;
            this.content = content;
            this.keywords = keywords;
        }
        
        /**
         * Tính toán độ liên quan của mục tri thức với câu hỏi của người dùng
         * Sử dụng thuật toán matching từ khóa và fuzzy matching
         * @param userMessage Câu hỏi của người dùng
         * @return Điểm số độ liên quan (càng cao càng liên quan)
         */
        double calculateRelevance(String userMessage) {
            String message = userMessage.toLowerCase();
            double score = 0.0;
            
            // Kiểm tra exact match với từ khóa
            for (String keyword : keywords) {
                if (message.contains(keyword.toLowerCase())) {
                    score += 1.0;
                    // Bonus điểm nếu câu hỏi chính xác bằng từ khóa
                    if (message.equals(keyword.toLowerCase())) {
                        score += 0.5;
                    }
                }
            }
            
            // Fuzzy matching cho các từ khóa gần giống
            for (String keyword : keywords) {
                if (fuzzyMatch(message, keyword.toLowerCase())) {
                    score += 0.3;
                }
            }
            
            return score;
        }
    }
    
    /**
     * Phương thức chính xử lý POST request từ client
     * Nhận câu hỏi từ người dùng và trả về câu trả lời từ AI
     * @param request HTTP request chứa câu hỏi
     * @param response HTTP response chứa câu trả lời
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Thiết lập encoding UTF-8 cho request và response
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        
        try {
            // Đọc dữ liệu từ request body
            String requestBody = getRequestBody(request);
            System.out.println("📥 Received request: " + requestBody);
            
            // Kiểm tra request body có hợp lệ không
            if (requestBody == null || requestBody.trim().isEmpty()) {
                sendErrorResponse(out, gson, "Request body trống", "Empty request");
                return;
            }
            
            // Parse JSON từ request
            JsonObject requestData = gson.fromJson(requestBody, JsonObject.class);
            String userMessage = requestData.get("message").getAsString().trim();
            
            System.out.println("💬 User message: " + userMessage);
            
            // RAG Pipeline: Tìm kiếm tri thức liên quan
            List<KnowledgeItem> relevantKnowledge = retrieveRelevantKnowledge(userMessage);
            
            String aiResponse;
            if (!relevantKnowledge.isEmpty()) {
                // Sử dụng RAG với context từ knowledge base
                try {
                    aiResponse = callGoogleAIWithRAG(userMessage, relevantKnowledge, request);
                    System.out.println("🤖 AI Response: " + aiResponse);
                } catch (Exception e) {
                    System.err.println("❌ AI API Error: " + e.getMessage());
                    // Fallback khi API lỗi
                    aiResponse = getEnhancedFallbackResponse(userMessage, relevantKnowledge, request);
                    System.out.println("🔄 Using enhanced fallback: " + aiResponse);
                }
            } else {
                // Không tìm thấy tri thức liên quan
                aiResponse = "🤔 Xin lỗi, câu hỏi của bạn không liên quan đến các dịch vụ nha khoa. Vui lòng hỏi về các dịch vụ như Implant, Niềng răng, Nha khoa trẻ em, hoặc liên hệ hotline 0854321230 để được tư vấn!";
                System.out.println("🔄 No relevant knowledge found: " + aiResponse);
            }
            
            // Lưu lịch sử trò chuyện
            saveChatHistory(request, userMessage, aiResponse);
            
            // Tạo JSON response
            JsonObject responseJson = new JsonObject();
            responseJson.addProperty("success", true);
            responseJson.addProperty("response", aiResponse);
            responseJson.addProperty("confidence", calculateConfidence(userMessage, relevantKnowledge));
            
            // Gửi response về client
            out.print(gson.toJson(responseJson));
            out.flush();
            
        } catch (Exception e) {
            System.err.println("💥 Servlet Error: " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(out, gson, "Lỗi hệ thống", "System error: " + e.getMessage());
        }
    }
    
    /**
     * Enhanced RAG: Tìm kiếm tri thức liên quan dựa trên câu hỏi của người dùng
     * Sử dụng thuật toán scoring để xếp hạng độ liên quan
     * @param userMessage Câu hỏi của người dùng
     * @return Danh sách các mục tri thức liên quan, sắp xếp theo độ liên quan
     */
    private List<KnowledgeItem> retrieveRelevantKnowledge(String userMessage) {
        List<KnowledgeItem> results = new ArrayList<>();
        
        // Tính điểm liên quan cho từng mục tri thức
        for (KnowledgeItem item : KNOWLEDGE_BASE.values()) {
            double relevance = item.calculateRelevance(userMessage);
            if (relevance > 0) {
                results.add(item);
            }
        }
        
        // Sắp xếp theo điểm liên quan giảm dần
        results.sort((a, b) -> Double.compare(b.calculateRelevance(userMessage), a.calculateRelevance(userMessage)));
        
        // Trả về top 3 mục liên quan nhất
        return results.subList(0, Math.min(3, results.size()));
    }
    
    /**
     * RAG-enhanced AI call: Gọi AI với context từ knowledge base
     * Sử dụng thông tin từ cơ sở tri thức để tăng độ chính xác của câu trả lời
     * @param userMessage Câu hỏi của người dùng
     * @param relevantKnowledge Danh sách tri thức liên quan
     * @param request HTTP request để lấy lịch sử chat
     * @return Câu trả lời từ AI
     */
    private String callGoogleAIWithRAG(String userMessage, List<KnowledgeItem> relevantKnowledge, HttpServletRequest request) throws IOException {
        StringBuilder context = new StringBuilder();
        
        // Thêm system prompt cho AI
        context.append("Bạn là trợ lý ảo chuyên nghiệp của Nha Khoa PDC, chỉ trả lời các câu hỏi liên quan đến các dịch vụ nha khoa như Implant, Niềng răng, Nha khoa trẻ em, Phẫu thuật hàm mặt, Thẩm mỹ nha khoa, Nhổ răng khôn. " +
                      "Sử dụng tiếng Việt tự nhiên, chuyên nghiệp và thân thiện. Nếu câu hỏi không rõ ràng, yêu cầu người dùng cung cấp thêm thông tin hoặc đề xuất liên hệ hotline 0854321230.\n\n");
        
        // Thêm context từ knowledge base
        for (KnowledgeItem item : relevantKnowledge) {
            context.append("=== ").append(item.title).append(" ===\n");
            context.append(item.content).append("\n\n");
        }
        
        // Thêm lịch sử trò chuyện để AI hiểu context
        @SuppressWarnings("unchecked")
        List<String> chatHistory = (List<String>) request.getSession().getAttribute("chatHistory");
        if (chatHistory != null && !chatHistory.isEmpty()) {
            context.append("Lịch sử trò chuyện:\n");
            for (String history : chatHistory) {
                context.append(history).append("\n");
            }
        }
        
        // Thêm câu hỏi hiện tại
        context.append("Câu hỏi hiện tại: ").append(userMessage);
        context.append("\n\nHãy trả lời một cách thân thiện, chuyên nghiệp và chi tiết, chỉ dựa trên thông tin nha khoa.");
        
        return callGoogleAI(context.toString());
    }
    
    /**
     * Enhanced fallback: Tạo câu trả lời dự phòng khi AI API không khả dụng
     * Chỉ sử dụng tri thức có sẵn từ knowledge base
     * @param userMessage Câu hỏi của người dùng
     * @param relevantKnowledge Tri thức liên quan (nếu có)
     * @param request HTTP request
     * @return Câu trả lời fallback
     */
    private String getEnhancedFallbackResponse(String userMessage, List<KnowledgeItem> relevantKnowledge, HttpServletRequest request) {
        // Nếu có tri thức liên quan, trả về thông tin đó
        if (!relevantKnowledge.isEmpty()) {
            KnowledgeItem bestMatch = relevantKnowledge.get(0);
            return bestMatch.content + "\n\n💡 *Để biết thêm thông tin chi tiết, bạn có thể liên hệ hotline 0854321230 để được tư vấn miễn phí.*";
        }
        
        // Không tìm thấy tri thức liên quan
        return "🤔 Xin lỗi, câu hỏi của bạn không liên quan đến các dịch vụ nha khoa. Vui lòng hỏi về các dịch vụ như Implant, Niềng răng, Nha khoa trẻ em, hoặc liên hệ hotline 0854321230 để được tư vấn!";
    }
    
    /**
     * Fuzzy matching: So khớp gần đúng giữa text và keyword
     * Dùng để tìm các từ khóa tương tự khi người dùng gõ sai chính tả
     * @param text Văn bản người dùng nhập
     * @param keyword Từ khóa cần so khớp
     * @return true nếu có độ tương tự
     */
    private static boolean fuzzyMatch(String text, String keyword) {
        if (keyword.length() < 3) return false;
        return text.contains(keyword.substring(0, Math.min(3, keyword.length())));
    }
    
    /**
     * Tính toán độ tin cậy của câu trả lời dựa trên độ liên quan của tri thức
     * @param userMessage Câu hỏi của người dùng
     * @param relevantKnowledge Tri thức liên quan
     * @return Điểm tin cậy từ 0.0 đến 1.0
     */
    private double calculateConfidence(String userMessage, List<KnowledgeItem> relevantKnowledge) {
        if (relevantKnowledge.isEmpty()) return 0.3;
        
        double maxRelevance = relevantKnowledge.get(0).calculateRelevance(userMessage);
        return Math.min(0.95, 0.5 + (maxRelevance * 0.1));
    }
    
    /**
     * Lưu lịch sử trò chuyện vào session để AI có thể tham khảo context
     * @param request HTTP request chứa session
     * @param userMessage Tin nhắn của người dùng
     * @param aiResponse Phản hồi của AI
     */
    private void saveChatHistory(HttpServletRequest request, String userMessage, String aiResponse) {
        @SuppressWarnings("unchecked")
        List<String> chatHistory = (List<String>) request.getSession().getAttribute("chatHistory");
        if (chatHistory == null) {
            chatHistory = new ArrayList<>();
            request.getSession().setAttribute("chatHistory", chatHistory);
        }
        
        // Thêm tin nhắn mới vào lịch sử
        chatHistory.add("Bạn: " + userMessage);
        chatHistory.add("PDC Bot: " + aiResponse);
        
        // Giữ chỉ 20 tin nhắn gần nhất để tránh session quá lớn
        if (chatHistory.size() > 20) {
            chatHistory = new ArrayList<>(chatHistory.subList(chatHistory.size() - 20, chatHistory.size()));
            request.getSession().setAttribute("chatHistory", chatHistory);
        }
    }
    
    /**
     * Core method: Gọi Google Gemini AI API
     * Tạo HTTP request tới Google AI và parse response
     * @param context Ngữ cảnh và câu hỏi gửi tới AI
     * @return Câu trả lời từ AI
     * @throws IOException Nếu có lỗi network hoặc API
     */
    private String callGoogleAI(String context) throws IOException {
        // Tạo connection tới Google AI API
        URL url = new URL(API_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setDoOutput(true);
        conn.setConnectTimeout(30000);  // 30 giây timeout
        conn.setReadTimeout(30000);     // 30 giây read timeout
        
        // Tạo JSON request body theo format của Google AI API
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
        
        // Thêm cấu hình grounding để AI có thể search thông tin thời gian thực
        JsonObject tools = new JsonObject();
        JsonObject googleSearchRetrieval = new JsonObject();
        googleSearchRetrieval.addProperty("type", "google_search_retrieval");
        JsonArray toolsArray = new JsonArray();
        toolsArray.add(googleSearchRetrieval);
        requestBody.add("tools", toolsArray);
        
        // Cấu hình generation để có câu trả lời tốt hơn
        JsonObject generationConfig = new JsonObject();
        generationConfig.addProperty("temperature", 0.7);      // Độ sáng tạo vừa phải
        generationConfig.addProperty("maxOutputTokens", 2048); // Giới hạn độ dài response
        generationConfig.addProperty("topP", 0.9);             // Nucleus sampling
        generationConfig.addProperty("topK", 40);              // Top-K sampling
        requestBody.add("generationConfig", generationConfig);
        
        // Gửi request
        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = requestBody.toString().getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }
        
        // Đọc response
        int responseCode = conn.getResponseCode();
        InputStream inputStream = (responseCode == 200) ? conn.getInputStream() : conn.getErrorStream();
        
        StringBuilder response = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line.trim());
            }
        }
        
        // Kiểm tra response code
        if (responseCode != 200) {
            throw new IOException("API Error " + responseCode + ": " + response.toString());
        }
        
        // Parse JSON response từ Google AI
        Gson gson = new Gson();
        JsonObject responseJson = gson.fromJson(response.toString(), JsonObject.class);
        
        // Trích xuất text từ response structure phức tạp của Google AI
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
    
    /**
     * Đọc toàn bộ request body từ HTTP request
     * @param request HTTP request
     * @return String chứa request body
     * @throws IOException Nếu có lỗi đọc dữ liệu
     */
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
    
    /**
     * Gửi error response về client khi có lỗi xảy ra
     * @param out PrintWriter để gửi response
     * @param gson Gson object để serialize JSON
     * @param userMessage Thông báo lỗi cho người dùng
     * @param errorDetails Chi tiết lỗi cho developer
     */
    private void sendErrorResponse(PrintWriter out, Gson gson, String userMessage, String errorDetails) {
        JsonObject errorResponse = new JsonObject();
        errorResponse.addProperty("success", false);
        errorResponse.addProperty("response", "Xin lỗi, " + userMessage + ". Vui lòng thử lại sau hoặc liên hệ hotline 0854321230.");
        errorResponse.addProperty("error", errorDetails);
        
        out.print(gson.toJson(errorResponse));
        out.flush();
    }
}