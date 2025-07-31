# frozen_string_literal: true

# Example prompt demonstrating MCP prompt functionality
class SamplePrompt < ApplicationPrompt
  prompt_name 'sample_query'
  description 'A sample prompt that handles user queries with optional context and formatting'

  arguments do
    required(:query).description('The main user question or request')
    optional(:context).description('Additional context to help answer the query')
    optional(:response_format).description('Response format: brief or detailed (default: brief)')
  end

  def call(query:, context: nil, response_format: 'brief')
    # Create messages using the hash format
    # Only 'user' and 'assistant' roles are supported
    messages(
      assistant: assistant_introduction(response_format),
      user: build_user_message(query, context, response_format)
    )
  end

  private

  # Helper method to create assistant introduction based on response format
  def assistant_introduction(format)
    case format&.downcase
    when 'detailed'
      "I'm ready to provide a comprehensive and detailed response to your question. "\
      "I'll include explanations, examples, and additional context where helpful."
    else
      "I'm ready to help with your question. I'll provide a clear and concise response."
    end
  end

  # Helper method to build the user message with all provided information
  def build_user_message(query, context, format)
    message_parts = ["My question is: #{query}"]
    
    if context
      message_parts << "Additional context: #{context}"
    end
    
    if format&.downcase == 'detailed'
      message_parts << "Please provide a detailed response with examples and explanations."
    else
      message_parts << "Please provide a brief, focused response."
    end
    
    message_parts.join("\n\n")
  end
end