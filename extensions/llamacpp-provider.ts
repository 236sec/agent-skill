import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default async function (pi: ExtensionAPI) {
  const baseUrl = "http://pc.local:12434/v1"; // Update with your llama.cpp docker container's URL and port

  let models: Array<{
    id: string;
    name: string;
    reasoning: boolean;
    input: string[];
    cost: {
      input: number;
      output: number;
      cacheRead: number;
      cacheWrite: number;
    };
    contextWindow: number;
    maxTokens: number;
  }> = [];

  // Fetch available models from your llama.cpp docker container
  try {
    const response = await fetch(`${baseUrl}/models`, {
      signal: AbortSignal.timeout(10000),
    }); // Set a timeout for the request
    if (response.ok) {
      const payload = (await response.json()) as {
        data: Array<{
          id: string;
          name?: string;
          context_window?: number;
          max_tokens?: number;
        }>;
      };
      models = payload.data.map((model) => ({
        id: model.id,
        name: model.name ?? model.id,
        reasoning: true, // Set to true if running a reasoning model like DeepSeek R1
        input: ["text"],
        cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
        contextWindow: model.context_window ?? 128000,
        maxTokens: model.max_tokens ?? 128000,
      }));
    }
  } catch (error) {
    // Silently fail - provider will register without models
    console.warn(
      `Failed to fetch models from ${baseUrl}: ${error instanceof Error ? error.message : "Unknown error"}`,
    );
  }

  pi.registerProvider("llama-local", {
    baseUrl: baseUrl,
    apiKey: "NO_KEY_REQUIRED", // Provide a dummy key if your docker container doesn't require auth
    api: "openai-completions",
    models: models,
  });
}
